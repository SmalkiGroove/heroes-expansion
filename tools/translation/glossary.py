"""Builds the translation glossary: the names of the mod's game entities (artifacts, creatures, spells...).

The glossary is keyed by English term, per category. The mod reuses vanilla IDs for different entities
(ARTIFACT_OGRE_CLUB is a cuirass), so a term gets the official translation of the vanilla entity that had the
same English name, in each language given with --texts. Terms no vanilla entity had are marked `new: true`.
`ids` lists the mod IDs that use the term.

Usage:
    python tools/translation/glossary.py --data "<TotE>/data" --texts EN=G:/__H5__/Z/texts-EN [--texts FR=...]
"""

import argparse
import os
import re
import sys
import xml.etree.ElementTree as ET
import zipfile

import yaml

TRANSLATION_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(os.path.dirname(TRANSLATION_DIR))
GAME_DATA = os.path.join(REPO_ROOT, "game_data")
TEXTS_EN = os.path.join(REPO_ROOT, "game_texts", "texts-EN")
OUTPUT = os.path.join(TRANSLATION_DIR, "glossary.yml")
CORRECTIONS = os.path.join(TRANSLATION_DIR, "glossary-corrections.yml")

VANILLA_PAKS = ["data.pak", "a2p1-data.pak"]  # later paks override earlier ones

# Names of unused or internal entities
PLACEHOLDERS = {"Debug Teleport", "Not Available", "Unknown", "None", "Plate", "True Tank"}
MAX_IDS = 5  # longer ID lists are cut


class VirtualFS:
    """Game files merged from layers (paks and folders); later layers override earlier ones. Paths are case-insensitive."""

    def __init__(self):
        self.files = {}

    def add_pak(self, pak_path):
        archive = zipfile.ZipFile(pak_path)
        for name in archive.namelist():
            if not name.endswith("/"):
                self.files["/" + name.lower()] = (archive, name)

    def add_folder(self, folder):
        for root, _, files in os.walk(folder):
            for file in files:
                full = os.path.join(root, file)
                rel = os.path.relpath(full, folder).replace("\\", "/")
                self.files["/" + rel.lower()] = (None, full)

    def read(self, path):
        entry = self.files.get(path.lower())
        if entry is None:
            return None
        archive, name = entry
        if archive is not None:
            return archive.read(name)
        with open(name, "rb") as f:
            return f.read()

    def paths(self, prefix, suffix=""):
        prefix, suffix = prefix.lower(), suffix.lower()
        return sorted(p for p in self.files if p.startswith(prefix) and p.endswith(suffix))


def resolve(href, from_path):
    """Game path of an href, relative to the referencing file unless absolute. None for an empty href."""
    if not href:
        return None
    href = href.split("#")[0]
    if not href:
        return None
    if href.startswith("/"):
        return href
    return from_path.rsplit("/", 1)[0] + "/" + href


class Game:
    """One state of the game: data files and texts in one language."""

    def __init__(self, data, texts):
        self.data = data
        self.texts = texts
        self.xml_cache = {}

    def xml(self, path):
        if path not in self.xml_cache:
            raw = self.data.read(path)
            self.xml_cache[path] = ET.fromstring(raw) if raw else None
        return self.xml_cache[path]

    def text(self, path):
        """Content of a text file, trimmed, or None when it is missing or empty."""
        if not path:
            return None
        raw = self.texts.read(path)
        if raw is None:
            return None
        if raw[:2] in (b"\xff\xfe", b"\xfe\xff"):
            content = raw.decode("utf-16")
        else:
            content = raw.decode("utf-16-le")
        return content.strip() or None

    def ref(self, node, from_path):
        """Game path that a node's href attribute points to."""
        return resolve(node.get("href"), from_path) if node is not None else None

    def table(self, path):
        """(ID, obj node) of each item of a RefTables table."""
        root = self.xml(path)
        if root is None:
            return
        for item in root.find("objects"):
            obj = item.find("obj")
            if obj is None:
                obj = item.find("Obj")
            yield item.findtext("ID"), obj


def extract(game):
    """Entity names of one game state: {category: {key: name}}."""
    terms = {}

    def add(category, key, text_path):
        name = clean_name(game.text(text_path), category)
        if name:
            terms.setdefault(category, {})[key] = name

    for path in game.texts.paths("/text/game/towns/types/", ".txt"):
        add("factions", path.rsplit("/", 1)[1][:-len(".txt")], path)

    path = "/GameMechanics/RefTables/Artifacts.xdb"
    for id, obj in game.table(path):
        add("artifacts", id, game.ref(obj.find("NameFileRef"), path))

    path = "/GameMechanics/RefTables/Skills.xdb"
    for id, obj in game.table(path):
        levels = obj.find("NameFileRef")
        items = list(levels) if levels is not None else []
        for level, item in enumerate(items, 1):
            add("skills", id if len(items) == 1 else f"{id}/{level}", game.ref(item, path))

    path = "/GameMechanics/RefTables/UndividedSpells.xdb"
    for id, obj in game.table(path):
        spell_path = game.ref(obj, path)
        spell = game.xml(spell_path) if spell_path else None
        if spell is not None:
            add("spells", id, game.ref(spell.find("NameFileRef"), spell_path))

    path = "/GameMechanics/RefTables/Creatures.xdb"
    for id, obj in game.table(path):
        creature_path = game.ref(obj, path)
        creature = game.xml(creature_path) if creature_path else None
        visual_path = game.ref(creature.find("Visual"), creature_path) if creature is not None else None
        visual = game.xml(visual_path) if visual_path else None
        if visual is not None:
            add("creatures", id, game.ref(visual.find("CreatureNameFileRef"), visual_path))

    path = "/GameMechanics/RefTables/CombatAbilities.xdb"
    for id, obj in game.table(path):
        add("abilities", id, game.ref(obj.find("NameFileRef"), path))

    for table, category in [("HeroClass", "classes"), ("HeroAttribute", "stats"), ("Mastery", "stats"), ("ResourcesInfo", "resources")]:
        path = f"/GameMechanics/RefTables/{table}.xdb"
        for id, obj in game.table(path):
            add(category, id, game.ref(obj.find("NameFileRef"), path))

    for path in game.data.paths("/mapobjects/", ".xdb"):
        root = game.xml(path)
        if root is None or root.tag != "AdvMapHeroShared":
            continue
        hero = root.findtext("InternalName")
        editable = root.find("Editable")
        if editable is not None:
            add("heroes", hero, game.ref(editable.find("NameFileRef"), path))
        add("specializations", hero, game.ref(root.find("SpecializationNameFileRef"), path))

    for path in game.data.paths("/gamemechanics/townbuildingsharedstats/", ".xdb"):
        root = game.xml(path)
        if root is not None:
            key = path[len("/gamemechanics/townbuildingsharedstats/"):-len(".xdb")]
            add("buildings", key, game.ref(root.find("NameFileRef"), path))

    return terms


def build(args):
    vanilla_data = VirtualFS()
    for pak in VANILLA_PAKS:
        vanilla_data.add_pak(os.path.join(args.data, pak))
    mod_data = VirtualFS()
    for pak in VANILLA_PAKS:
        mod_data.add_pak(os.path.join(args.data, pak))
    for folder in sorted(os.listdir(GAME_DATA)):
        mod_data.add_folder(os.path.join(GAME_DATA, folder))

    vanilla = {}
    for lang, folder in args.texts:
        texts = VirtualFS()
        texts.add_folder(folder)
        vanilla[lang] = extract(Game(vanilla_data, texts))
    if "EN" not in vanilla:
        sys.exit("--texts EN=<folder> (the vanilla English texts) is required")

    # Mod texts (texts-EN and the UI-local texts of game_data) override the vanilla English texts
    mod_texts = VirtualFS()
    mod_texts.add_folder(dict(args.texts)["EN"])
    mod_texts.add_folder(TEXTS_EN)
    for folder in sorted(os.listdir(GAME_DATA)):
        mod_texts.add_folder(os.path.join(GAME_DATA, folder))
    mod = extract(Game(mod_data, mod_texts))

    # Vanilla (category, ID) of each English name, in the same category first, then in any category
    by_name = {}
    for category, entries in vanilla["EN"].items():
        for id, name in entries.items():
            by_name.setdefault((category, name.lower()), []).append((category, id))
            by_name.setdefault((None, name.lower()), []).append((category, id))

    glossary = {}
    others = [lang for lang, _ in args.texts if lang != "EN"]
    for category, entries in mod.items():
        terms = {}
        for id, name in sorted(entries.items(), key=lambda kv: natural(kv[0])):
            terms.setdefault(name, []).append(id)
        out = glossary.setdefault(category, {})
        for name in sorted(terms, key=natural):
            ids = terms[name]
            entry = {"ids": ids if len(ids) <= MAX_IDS else ids[:MAX_IDS] + [f"... {len(ids) - MAX_IDS} more"]}
            matches = by_name.get((category, name.lower())) or by_name.get((None, name.lower()))
            if not matches:
                entry["new"] = True
            for lang in others:
                candidates = [vanilla[lang].get(c, {}).get(id) for c, id in matches or []]
                official = most_common(candidates)
                if official:
                    entry[lang.lower()] = official
                if len(set(filter(None, candidates))) > 1:
                    print(f"WARNING: {category} '{name}' has several {lang} names, kept '{official}': {sorted(set(filter(None, candidates)))}")
            out[name] = entry
    apply_corrections(glossary)
    return glossary


def apply_corrections(glossary):
    """Replaces official names with the hand-made ones of glossary-corrections.yml ({term: {lang: name}}),
    in every category that has the term."""
    with open(CORRECTIONS, encoding="utf-8") as f:
        corrections = yaml.safe_load(f) or {}
    for term, names in corrections.items():
        entries = [entries[term] for entries in glossary.values() if term in entries]
        if not entries:
            print(f"WARNING: correction of '{term}', which is not in the glossary")
        for entry in entries:
            entry.update({lang.lower(): name for lang, name in names.items()})


def clean_name(text, category):
    """The name alone: first line without tags. Mod specialization names also carry the class and the description.
    None for a placeholder name."""
    if not text:
        return None
    name = re.sub(r"<[^>]*>", "", text.splitlines()[0]).strip()
    if category == "specializations":
        name = name.split(" - ")[0].strip()
    if not name or name.startswith(("[", "TODO")) or name in PLACEHOLDERS:
        return None
    return name


def most_common(values):
    values = [v for v in values if v]
    return max(values, key=values.count) if values else None


def natural(key):
    return [int(part) if part.isdigit() else part.lower() for part in re.split(r"(\d+)", key)]


def lang_folder(value):
    lang, sep, folder = value.partition("=")
    if not sep or not os.path.isdir(folder):
        raise argparse.ArgumentTypeError(f"expected LANG=<existing folder>, got {value}")
    return lang.upper(), folder


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--data", required=True, help="vanilla game data folder (with data.pak and a2p1-data.pak)")
    parser.add_argument("--texts", type=lang_folder, action="append", required=True,
                        help="extracted vanilla texts of one language, as LANG=folder (EN is required)")
    parser.add_argument("--dry-run", action="store_true", help="print the counts but write no file")
    args = parser.parse_args()

    glossary = build(args)
    for category, entries in glossary.items():
        new = sum(1 for e in entries.values() if e.get("new"))
        print(f"{category:16} {len(entries):5} terms, {new:4} new")
    if not args.dry_run:
        with open(OUTPUT, "w", encoding="utf-8", newline="\r\n") as f:
            f.write("# Generated by tools/translation/glossary.py. Don't edit; rerun the script.\n")
            yaml.safe_dump(glossary, f, allow_unicode=True, sort_keys=False, width=200, default_flow_style=None)
        print(f"Wrote {os.path.relpath(OUTPUT, REPO_ROOT)}")


if __name__ == "__main__":
    main()
