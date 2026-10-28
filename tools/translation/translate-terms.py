"""Translates the glossary terms that vanilla doesn't have (`new: true` in glossary.yml) into glossary-new.yml.

Only missing names are translated: a name already in glossary-new.yml is never changed, so it can be reviewed
and edited by hand. The whole official glossary is sent as reference, so new names follow the vanilla style.
Rerun glossary.py afterwards to merge the names into glossary.yml.

Needs the `anthropic` package and an API key (ANTHROPIC_API_KEY).

Usage:
    python tools/translation/translate-terms.py [--lang FR --lang PL] [--category skills] [--limit 20] [--dry-run]
"""

import argparse
import json
import os
import sys

import yaml

TRANSLATION_DIR = os.path.dirname(os.path.abspath(__file__))
GLOSSARY = os.path.join(TRANSLATION_DIR, "glossary.yml")
NEW_TERMS = os.path.join(TRANSLATION_DIR, "glossary-new.yml")

LANGUAGES = {"FR": "French", "PL": "Polish", "RU": "Russian"}
MODEL = "claude-opus-5-5"
BATCH_SIZE = 40

NEW_TERMS_HEADER = """\
# Translations of the glossary terms that vanilla doesn't have (`new: true` in glossary.yml).
# tools/translation/translate-terms.py adds the missing ones; it never changes a name already here,
# so names can be reviewed and edited by hand (comments are not kept). glossary.py merges them into glossary.yml.
#
# English term:
#   fr: name
#   pl: name
#   ru: name
"""

INSTRUCTIONS = """\
You translate game terms for H5X, a mod for Heroes of Might and Magic V: Tribes of the East. The mod adds \
heroes, classes, skills, creatures, abilities, artifacts, spells and buildings, and its texts are translated \
from English into French, Polish and Russian.

Below is the official glossary of the original game: the English name of each entity and its official name in \
each language, by category. Players know these names, so a new name must read as if it came from the same \
official translation:
- Reuse the official wording for any part of a new term that is an official term or close to one. For example, \
a new skill level such as "Absolute Necromancy" uses the official name of Necromancy, and a mastery prefix \
(Basic, Advanced, Expert, Absolute) is rendered the way the official skill names render mastery levels.
- Follow the conventions of each language in the glossary: capitalization, word order, the length of names, \
and grammatical forms. In Russian, creature names are plural (Angel is Ангелы).
- Hero names are proper names: keep them, adapting only the way the official translation adapts names \
(Cyrillic transliteration in Russian, the occasional spelling adaptation in Polish).
- Translate what the term means in the game, using the context given with it, not word for word. Keep \
the meaning of an invented name (Bulwark Rune is a rune that acts as a bulwark).
- A term that appears in several categories gets one translation.

Answer with a translation of every requested term in every requested language."""


def load_yaml(path):
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def official_glossary(glossary, langs):
    """The official names, one line per term: category | English | names in each language."""
    lines = ["category | English | " + " | ".join(LANGUAGES[lang] for lang in langs)]
    for category, entries in glossary.items():
        for term, entry in entries.items():
            if not entry.get("new"):
                lines.append(" | ".join([category, term] + [entry.get(lang.lower(), "") for lang in langs]))
    return "\n".join(lines)


def missing_terms(glossary, new_terms, langs, categories):
    """[(term, category, description, missing languages)] of the new terms, each term once."""
    seen = set()
    result = []
    for category, entries in glossary.items():
        if categories and category not in categories:
            continue
        for term, entry in entries.items():
            if not entry.get("new") or term in seen:
                continue
            seen.add(term)
            done = new_terms.get(term) or {}
            missing = [lang for lang in langs if lang.lower() not in done]
            if missing:
                result.append((term, category, entry.get("desc", ""), missing))
    return result


def output_schema(langs):
    properties = {"en": {"type": "string"}}
    properties.update({lang.lower(): {"type": "string"} for lang in langs})
    return {
        "type": "object",
        "properties": {
            "terms": {
                "type": "array",
                "items": {"type": "object", "properties": properties, "required": list(properties), "additionalProperties": False},
            }
        },
        "required": ["terms"],
        "additionalProperties": False,
    }


def request(batch, langs):
    terms = [{"en": term, "category": category, "context": desc} for term, category, desc, _ in batch]
    return ("Translate these terms into " + ", ".join(LANGUAGES[lang] for lang in langs) + ":\n"
            + json.dumps(terms, ensure_ascii=False, indent=1))


def translate(client, system, batch, langs):
    """{term: {lang: name}} for a batch, from one request."""
    response = client.beta.messages.create(
        model=MODEL,
        max_tokens=16000,
        betas=["server-side-fallback-2026-07-01"],
        fallbacks="default",
        system=[{"type": "text", "text": system, "cache_control": {"type": "ephemeral"}}],
        output_config={"effort": "high", "format": {"type": "json_schema", "schema": output_schema(langs)}},
        messages=[{"role": "user", "content": request(batch, langs)}],
    )
    if response.stop_reason == "refusal":
        print(f"ERROR: request refused ({response.stop_details})")
        return {}
    if response.stop_reason == "max_tokens":
        print("ERROR: answer cut at max_tokens, try a smaller --batch")
        return {}
    text = next(block.text for block in response.content if block.type == "text")
    usage = response.usage
    print(f"  tokens: {usage.input_tokens} in, {usage.cache_read_input_tokens or 0} cached, {usage.output_tokens} out")
    return {item["en"]: {lang: item[lang.lower()].strip() for lang in langs} for item in json.loads(text)["terms"]}


def save(new_terms):
    with open(NEW_TERMS, "w", encoding="utf-8", newline="\r\n") as f:
        f.write(NEW_TERMS_HEADER)
        if new_terms:
            ordered = {term: new_terms[term] for term in sorted(new_terms, key=str.lower)}
            yaml.safe_dump(ordered, f, allow_unicode=True, sort_keys=False, width=200)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--lang", action="append", choices=list(LANGUAGES), help="language to translate (default: all)")
    parser.add_argument("--category", action="append", help="only the new terms of this glossary category")
    parser.add_argument("--limit", type=int, help="translate at most this many terms")
    parser.add_argument("--batch", type=int, default=BATCH_SIZE, help=f"terms per request (default {BATCH_SIZE})")
    parser.add_argument("--dry-run", action="store_true", help="print the batches and the first request, call nothing")
    args = parser.parse_args()
    langs = args.lang or list(LANGUAGES)

    glossary = load_yaml(GLOSSARY)
    new_terms = load_yaml(NEW_TERMS)
    todo = missing_terms(glossary, new_terms, langs, args.category)[:args.limit]
    batches = [todo[i:i + args.batch] for i in range(0, len(todo), args.batch)]
    print(f"{len(todo)} terms to translate in {len(batches)} requests")
    if not todo:
        return

    system = INSTRUCTIONS + "\n\nOfficial glossary:\n" + official_glossary(glossary, langs)
    if args.dry_run:
        print(f"System prompt: {len(system)} characters, {system.count(chr(10))} lines")
        print(request(batches[0], langs))
        return

    import anthropic
    client = anthropic.Anthropic()
    failed = 0
    for number, batch in enumerate(batches, 1):
        print(f"Request {number}/{len(batches)}: {batch[0][1]}, {batch[0][0]} ... {batch[-1][0]}")
        try:
            names = translate(client, system, batch, langs)
        except anthropic.APIStatusError as err:
            print(f"ERROR: {err.status_code} {err.message}")
            names = {}
        for term, _, _, missing in batch:
            if term not in names:
                print(f"  missing in the answer: {term}")
                failed += 1
                continue
            entry = new_terms.setdefault(term, {})
            for lang in missing:
                entry.setdefault(lang.lower(), names[term][lang])
        save(new_terms)
    print(f"Wrote {os.path.basename(NEW_TERMS)}" + (f", {failed} terms missing (rerun to retry)" if failed else ""))
    if failed:
        sys.exit(1)


if __name__ == "__main__":
    main()
