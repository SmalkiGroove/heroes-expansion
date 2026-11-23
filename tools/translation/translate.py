"""Machine-translates game_texts/texts-EN and texts-duel-EN into the other languages with Claude (Claude Code CLI).

A manifest per language (manifest-<LANG>.json) keeps, for each file, the hash of the English text that was
translated and the hash of the file written. So:
- a file is translated when it is missing or its English text changed;
- a translation edited by hand is kept until its English text changes (then it is retranslated, with a warning);
- a translation whose English file no longer exists is deleted.

Tags (<value=...>, <color=...>, <br>...) are replaced with placeholders, so Claude sees whole sentences, and a
translation is only written when it has the same placeholders in the same order and the same line breaks.
Each request carries the glossary terms (glossary.yml) found in its texts. Files without words and non-text
files are copied as they are.

Needs the Claude Code CLI (`claude`), logged in.

Usage:
    python tools/translation/translate.py [--lang FR] [--path Text/Game/Skills] [--limit 100] [--jobs 3] [--dry-run]
"""

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import threading
from concurrent.futures import ThreadPoolExecutor

import yaml

TRANSLATION_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(os.path.dirname(TRANSLATION_DIR))
GAME_TEXTS = os.path.join(REPO_ROOT, "game_texts")
GLOSSARY = os.path.join(TRANSLATION_DIR, "glossary.yml")

SOURCES = ["texts-EN", "texts-duel-EN"]  # the target folder replaces EN with the language
LANGUAGES = {"FR": "French", "PL": "Polish", "RU": "Russian"}
BATCH_CHARS = 12000  # English characters per request
BATCH_FILES = 80

TAG = re.compile(r"<[^>]*>")
PLACEHOLDER = re.compile(r"⟦\d+⟧")
WORD = re.compile(r"[A-Za-z]{2,}")

LANGUAGE_NOTES = {
    "FR": "Use the style of the original French game texts.",
    "PL": "Use the style of the original Polish game texts.",
    "RU": "Use the style of the original Russian game texts. Creature names in the glossary are plural "
          "(Ангелы for Angel): inflect them to fit the sentence, singular where the English is singular.",
}

INSTRUCTIONS = """\
You translate the texts of H5X, a mod for Heroes of Might and Magic V: Tribes of the East, from English into \
{language}. The texts are descriptions and labels shown in the game: skills, spells, creatures, artifacts, \
heroes, buildings, interface.

Rules:
- Translate the meaning naturally, in the tone of the official {language} translation of the game.
- Game terms: when the English text refers to a term of the glossary given with the texts, use the glossary \
name, inflected as the sentence needs. Never translate a glossary term differently.
- Placeholders such as ⟦0⟧ stand for formatting tags and game values. Keep every placeholder exactly as it is, \
the same number of times and in the same order, at the place the sentence needs it.
- Keep the line breaks: the translation has exactly as many lines as the English text.
- Keep numbers, percentages, signs and units as they are written (+2, 15%, -1).
- Keep hero names and other proper names unless the glossary gives a translation.
- {notes}

You get a glossary and a JSON array of texts, each with an "id" and a "text". Answer with the translation of \
every text, under the same id."""


def sha1(data):
    return hashlib.sha1(data).hexdigest()


class Text:
    """An English file to translate: its text with tags replaced by placeholders."""

    def __init__(self, key, raw):
        self.key = key
        self.raw = raw
        self.bom = raw[:2] == b"\xff\xfe"
        content = raw.decode("utf-16")
        self.crlf = "\r\n" in content
        content = content.replace("\r\n", "\n")
        self.tags = TAG.findall(content)
        counter = iter(range(len(self.tags)))
        self.prepared = TAG.sub(lambda _: f"⟦{next(counter)}⟧", content)

    def check(self, translated):
        """Error message when a translation doesn't keep the placeholders and line breaks, else None."""
        expected = [f"⟦{i}⟧" for i in range(len(self.tags))]
        if PLACEHOLDER.findall(translated) != expected:
            return f"placeholders {PLACEHOLDER.findall(translated)} instead of {expected}"
        if translated.count("\n") != self.prepared.count("\n"):
            return f"{translated.count(chr(10)) + 1} lines instead of {self.prepared.count(chr(10)) + 1}"
        return None

    def output(self, translated):
        """The file content of a checked translation."""
        content = PLACEHOLDER.sub(lambda m: self.tags[int(m.group()[1:-1])], translated)
        if self.crlf:
            content = content.replace("\n", "\r\n")
        return (b"\xff\xfe" if self.bom else b"") + content.encode("utf-16-le")


def source_files(path_filter):
    """{key: absolute path} of the English files; the key is the path under game_texts, with / separators."""
    files = {}
    for source in SOURCES:
        root = os.path.join(GAME_TEXTS, source)
        for folder, _, names in os.walk(root):
            for name in names:
                full = os.path.join(folder, name)
                rel = os.path.relpath(full, root).replace("\\", "/")
                if path_filter and not rel.lower().startswith(path_filter.lower()):
                    continue
                files[f"{source}/{rel}"] = full
    return files


def target_path(key, lang):
    source, rel = key.split("/", 1)
    return os.path.join(GAME_TEXTS, source.replace("EN", lang), *rel.split("/"))


def is_translatable(name, raw):
    """Text files with words; anything else (numbers, tags only, non-text files) is copied."""
    if not name.lower().endswith(".txt") or raw[:2] != b"\xff\xfe":
        return False
    try:
        content = raw.decode("utf-16")
    except UnicodeDecodeError:
        return False
    return bool(WORD.search(TAG.sub("", content)))


def load_glossary(lang):
    """[(English term, category, name, pattern)] of the glossary terms that have a name in the language."""
    with open(GLOSSARY, encoding="utf-8") as f:
        glossary = yaml.safe_load(f)
    terms = []
    for category, entries in glossary.items():
        for term, entry in entries.items():
            name = entry.get(lang.lower())
            if name:
                pattern = re.compile(r"(?<![A-Za-z])" + re.escape(term) + r"(?![A-Za-z])", re.IGNORECASE)
                terms.append((term, category, name, pattern))
    return terms


def batch_glossary(terms, texts):
    """Glossary lines for the terms that appear in a batch."""
    joined = "\n".join(text.prepared for text in texts)
    found = {}  # (term, name): categories
    for term, category, name, pattern in terms:
        if pattern.search(joined):
            found.setdefault((term, name), []).append(category)
    lines = [f"{term} ({', '.join(categories)}) = {name}" for (term, name), categories in found.items()]
    return "\n".join(sorted(lines, key=str.lower)) or "(no glossary term in these texts)"


def make_batches(texts, max_chars, max_files):
    batches, current, size = [], [], 0
    for text in texts:
        if current and (size + len(text.prepared) > max_chars or len(current) >= max_files):
            batches.append(current)
            current, size = [], 0
        current.append(text)
        size += len(text.prepared)
    if current:
        batches.append(current)
    return batches


ANSWER_SCHEMA = {
    "type": "object",
    "properties": {
        "texts": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {"id": {"type": "string"}, "text": {"type": "string"}},
                "required": ["id", "text"],
                "additionalProperties": False,
            },
        }
    },
    "required": ["texts"],
    "additionalProperties": False,
}

# The texts go on stdin (a Windows command line is limited to ~32K characters), this short request in argv
REQUEST = "Translate the texts given on standard input, following the system prompt."

# A key in the environment would override the claude.ai login in print mode
API_CREDENTIALS = ("ANTHROPIC_API_KEY", "ANTHROPIC_AUTH_TOKEN")


class UsageLimit(Exception):
    """The Claude plan's usage limit is reached: retrying is pointless until it resets."""


class Claude:
    """Calls the Claude Code CLI in print mode with the claude.ai login: no tools, no project customizations
    (--safe-mode), no saved session, answer validated against ANSWER_SCHEMA."""

    def __init__(self, model, effort, system):
        self.executable = shutil.which("claude")
        if not self.executable:
            sys.exit("The Claude Code CLI (claude) is not installed or not on the PATH")
        self.env = {key: value for key, value in os.environ.items() if key not in API_CREDENTIALS}
        self.workdir = tempfile.mkdtemp(prefix="h5x-translate-")  # outside the repo, so nothing of it loads
        self.system_file = os.path.join(self.workdir, "system.txt")
        with open(self.system_file, "w", encoding="utf-8") as f:
            f.write(system)
        self.model = model
        self.effort = effort
        status = subprocess.run([self.executable, "auth", "status"], capture_output=True, env=self.env)
        if status.returncode:
            sys.exit("The Claude Code CLI is not logged in: run `claude auth login`")

    def ask(self, prompt):
        """{id: text} of the answer."""
        command = [self.executable, "-p", REQUEST, "--safe-mode", "--no-session-persistence",
                   "--system-prompt-file", self.system_file, "--model", self.model, "--effort", self.effort,
                   "--output-format", "json", "--json-schema", json.dumps(ANSWER_SCHEMA), "--max-turns", "3",
                   "--tools", "", "--disallowedTools", "mcp__*"]
        result = subprocess.run(command, input=prompt.encode("utf-8"), capture_output=True,
                                env=self.env, cwd=self.workdir, timeout=1800)
        stdout = result.stdout.decode("utf-8", "replace")
        stderr = result.stderr.decode("utf-8", "replace")
        try:
            answer = json.loads(stdout)
        except json.JSONDecodeError:
            answer = {}
        if result.returncode or answer.get("is_error") or "structured_output" not in answer:
            message = (str(answer.get("result") or stdout[-500:]) + " " + stderr[-500:]).strip()
            if re.search(r"hit your (session|weekly|usage) limit|usage limit", message, re.IGNORECASE):
                raise UsageLimit(message[:300])
            raise RuntimeError(f"exit {result.returncode}: {message[:500]}")
        return {str(item["id"]): item["text"] for item in answer["structured_output"]["texts"]}


class Run:
    def __init__(self, args, lang):
        self.args = args
        self.lang = lang
        self.manifest_path = os.path.join(TRANSLATION_DIR, f"manifest-{lang}.json")
        self.manifest = {}
        if os.path.exists(self.manifest_path):
            with open(self.manifest_path, encoding="utf-8") as f:
                self.manifest = json.load(f)
        self.lock = threading.Lock()
        self.failed = []
        self.stopped = None  # usage limit message, once reached

    def save_manifest(self):
        with open(self.manifest_path, "w", encoding="utf-8", newline="\r\n") as f:
            json.dump(dict(sorted(self.manifest.items())), f, ensure_ascii=False, indent=1)
            f.write("\n")

    def write(self, key, data, source_hash):
        path = target_path(key, self.lang)
        with self.lock:
            if not self.args.dry_run:
                os.makedirs(os.path.dirname(path), exist_ok=True)
                with open(path, "wb") as f:
                    f.write(data)
                self.manifest[key] = {"src": source_hash, "out": sha1(data)}
                self.save_manifest()

    def plan(self):
        """(texts to translate, files to copy) and the stale translations removed."""
        sources = source_files(self.args.path)
        to_translate, to_copy = [], []
        for key, full in sorted(sources.items()):
            with open(full, "rb") as f:
                raw = f.read()
            path = target_path(key, self.lang)
            entry = self.manifest.get(key)
            current = None
            if os.path.exists(path):
                with open(path, "rb") as f:
                    current = sha1(f.read())
            if entry and entry["src"] == sha1(raw) and current:
                if current != entry["out"]:
                    print(f"Keep hand edits: {os.path.relpath(path, REPO_ROOT)}")
                continue
            if entry and current and current != entry["out"]:
                print(f"WARNING: English changed, hand edits replaced: {os.path.relpath(path, REPO_ROOT)}")
            if is_translatable(key, raw):
                to_translate.append(Text(key, raw))
            else:
                to_copy.append((key, raw))
        if not self.args.path:
            self.remove_stale(sources)
        return to_translate[:self.args.limit], to_copy

    def remove_stale(self, sources):
        for source in SOURCES:
            root = os.path.join(GAME_TEXTS, source.replace("EN", self.lang))
            for folder, _, names in os.walk(root):
                for name in names:
                    full = os.path.join(folder, name)
                    key = f"{source}/{os.path.relpath(full, root).replace(os.sep, '/')}"
                    if key not in sources:
                        print(f"Remove stale {os.path.relpath(full, REPO_ROOT)}")
                        if not self.args.dry_run:
                            os.remove(full)
                            self.manifest.pop(key, None)
        if not self.args.dry_run:
            self.save_manifest()

    def translate_batch(self, claude, terms, batch, number, total):
        if self.stopped:
            self.failed.extend(text.key for text in batch)
            return
        items = [{"id": str(i), "text": text.prepared} for i, text in enumerate(batch)]
        prompt = ("Glossary (English term (category) = " + LANGUAGES[self.lang] + " name):\n"
                  + batch_glossary(terms, batch) + "\n\nTexts:\n" + json.dumps(items, ensure_ascii=False, indent=1))
        try:
            answer = claude.ask(prompt)
        except UsageLimit as err:
            if not self.stopped:
                print(f"[{self.lang}] Usage limit reached, stopping: {err}")
            self.stopped = str(err)
            self.failed.extend(text.key for text in batch)
            return
        except (RuntimeError, ValueError, KeyError, TypeError, subprocess.TimeoutExpired) as err:
            print(f"[{self.lang} {number}/{total}] ERROR: {err}")
            if len(batch) > 1:  # one bad answer shouldn't lose the whole batch: retry in halves
                half = len(batch) // 2
                self.translate_batch(claude, terms, batch[:half], number, total)
                self.translate_batch(claude, terms, batch[half:], number, total)
            else:
                self.failed.append(batch[0].key)
            return
        written = 0
        for i, text in enumerate(batch):
            translated = answer.get(str(i))
            error = "missing in the answer" if translated is None else text.check(translated)
            if error:
                print(f"[{self.lang} {number}/{total}] {text.key}: {error}")
                self.failed.append(text.key)
                continue
            self.write(text.key, text.output(translated), sha1(text.raw))
            written += 1
        print(f"[{self.lang} {number}/{total}] {written}/{len(batch)} files")

    def run(self):
        to_translate, to_copy = self.plan()
        for key, raw in to_copy:
            self.write(key, raw, sha1(raw))
        batches = make_batches(to_translate, self.args.batch_chars, BATCH_FILES)
        chars = sum(len(text.prepared) for text in to_translate)
        print(f"{self.lang}: {len(to_copy)} files copied, {len(to_translate)} to translate "
              f"({chars} characters) in {len(batches)} requests")
        if self.args.dry_run or not batches:
            return
        system = INSTRUCTIONS.format(language=LANGUAGES[self.lang], notes=LANGUAGE_NOTES[self.lang])
        claude = Claude(self.args.model, self.args.effort, system)
        terms = load_glossary(self.lang)
        with ThreadPoolExecutor(max_workers=self.args.jobs) as pool:
            futures = [pool.submit(self.translate_batch, claude, terms, batch, number, len(batches))
                       for number, batch in enumerate(batches, 1)]
            for future in futures:
                future.result()  # raises what a thread raised
        if self.failed:
            print(f"{self.lang}: {len(self.failed)} files not translated (rerun to retry): " + ", ".join(self.failed[:20]))


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--lang", action="append", choices=list(LANGUAGES), help="language to translate (default: all)")
    parser.add_argument("--path", help="only the files under this path (relative to texts-EN, e.g. Text/Game/Skills)")
    parser.add_argument("--limit", type=int, help="translate at most this many files per language")
    parser.add_argument("--jobs", type=int, default=3, help="requests run at the same time (default 3)")
    parser.add_argument("--batch-chars", type=int, default=BATCH_CHARS, help=f"English characters per request (default {BATCH_CHARS})")
    parser.add_argument("--model", default="opus", help="Claude model, as the CLI's --model takes it (default opus)")
    parser.add_argument("--effort", default="medium", choices=["low", "medium", "high", "xhigh", "max"], help="effort level (default medium)")
    parser.add_argument("--dry-run", action="store_true", help="show what would be translated, call nothing, write nothing")
    args = parser.parse_args()
    failed = False
    for lang in args.lang or list(LANGUAGES):
        run = Run(args, lang)
        run.run()
        failed = failed or bool(run.failed)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
