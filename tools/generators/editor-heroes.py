"""Map editor hero palette: "Heroes by class" = the 16 H5X classes, "All heroes" = the heroes of Any.xdb.

The editor's categories are folders of AdvMapObjectLink files (editor/editor/MapFilters.xml):
GenericHeroes/ is "Heroes by class", Heroes/ is "All heroes". A link only shows once it is
listed in core/index.bin, and HideInEditor hides it even when listed.

Writes, in game_data/heroes/MapObjects:
  _(AdvMapSharedGroup)/Heroes/Classes/<Class>.xdb      one random group per class (6 heroes)
  _(AdvMapObjectLink)/GenericHeroes/<Class>.xdb        one link per class, RndGroup = the class group
  _(AdvMapObjectLink)/Heroes/<Faction>/<Hero>.(AdvMapObjectLink).xdb   one link per hero of Any.xdb
  hidden overrides (HideInEditor true) for every other vanilla or mod link of both folders
and the hero icons in editor/Complete/Icons/Generated/MapObjects/_(AdvMapObjectLink)/Heroes/<Faction>/.

Then add the new links and groups to core/index.bin (H5X_DLL tools/h5index/h5index.py update
--links-under ...), sync heroes, core and editor, and delete the GenericHeroes and Heroes folders of
H5Xdev/editor/IconCache/AdvMapObjectLink/MapObjects/_(AdvMapObjectLink): the editor keeps the icon it
cached for a link path, even after the link's IconFile changes. Never delete the whole IconCache: the
vanilla icons are lost (H5Xprod/editor/IconCache has a full copy).
"""

import argparse
import os
import re

from editor_links import GAME_DATA, LINKS, Sources, Writer, file_name, game_path, group_xdb, href, link_xdb, same_case, tag

HEROES = os.path.join(GAME_DATA, "heroes")
ANY_GROUP = "/MapObjects/_(AdvMapSharedGroup)/Heroes/Any.xdb"
GROUPS = "MapObjects/_(AdvMapSharedGroup)/Heroes/Classes"
FOLDERS = ("GenericHeroes", "Heroes")

# Hero file folder -> faction folder of the scenario links, and the (might, magic) classes
FACTIONS = {
    "Haven": ("Haven", "HAVEN"),
    "Preserve": ("Preserve", "PRESERVE"),
    "Dwarves": ("Fortress", "FORTRESS"),
    "Academy": ("Academy", "ACADEMY"),
    "Dungeon": ("Dungeon", "DUNGEON"),
    "Necropolis": ("Necropolis", "NECROPOLIS"),
    "Inferno": ("Inferno", "INFERNO"),
    "Stronghold": ("Stronghold", "STRONGHOLD"),
}
# Special classes join the might class of their faction
SPECIAL_CLASSES = {"HERO_CLASS_BATTLE_COMMANDER": "MIGHT", "HERO_CLASS_VAMPIRE_PRINCESS": "MIGHT"}
# Class icons already in editor/.../Classes/ use these faction names
ICON_FACTION = {"NECROPOLIS": "Necro"}


def class_names(src):
    table = src.read("/GameMechanics/RefTables/HeroClass.xdb").decode("utf-8")
    names = {}
    for m in re.finditer(r"<ID>(HERO_CLASS_[A-Z_]+)</ID>.*?<NameFileRef href=\"([^\"]*)\"", table, re.S):
        ref = m.group(2)
        name = src.text(ref if ref.startswith("/") else game_path("GameMechanics/RefTables", ref))
        if name:
            names[m.group(1)] = name
    return names


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true", help="print what would be written, write nothing")
    args = parser.parse_args()
    src, out = Sources(), Writer(HEROES, args.dry_run)
    names = class_names(src)
    vanilla_path = same_case(src, FOLDERS)

    heroes = []
    for h in re.findall(r'href="([^"]+)"', src.read(ANY_GROUP).decode("utf-8")):
        xml = src.read(h).decode("utf-8", "replace")
        faction, prefix = FACTIONS[h.split("/")[2]]
        cls = tag(xml, "Class")
        if cls in SPECIAL_CLASSES:
            cls = f"HERO_CLASS_{prefix}_{SPECIAL_CLASSES[cls]}"
        name = src.text(href(xml, "NameFileRef")) or tag(xml, "InternalName")
        heroes.append(dict(href=h, xml=xml, faction=faction, prefix=prefix, cls=cls, name=name))

    # Generic: one group and one link per class
    written = set()
    for faction, prefix in FACTIONS.values():
        for kind in ("MIGHT", "MAGIC"):
            cls = f"HERO_CLASS_{prefix}_{kind}"
            members = [x["href"] for x in heroes if x["cls"] == cls]
            cname = file_name(names[cls])
            out.text(game_path(GROUPS, cname + ".xdb"), group_xdb(members))
            icon = "Icons\\Generated\\MapObjects\\_(AdvMapObjectLink)\\Classes\\" \
                   f"{ICON_FACTION.get(prefix, faction)}-{kind.lower()}.tga"
            rel = vanilla_path(game_path(LINKS, "GenericHeroes", cname + ".xdb"))
            out.text(rel, link_xdb(group="/" + game_path(GROUPS, cname + ".xdb") + "#xpointer(/AdvMapSharedGroup)", icon=icon))
            written.add(rel.lower())
            print(f"{names[cls]:14} {len(members)} heroes")

    # Scenario: one link per hero, named after its English name
    used = set()
    for x in heroes:
        base = file_name(x["name"]) or x["href"].split("/")[-1].split(".")[0]
        if (x["faction"], base.lower()) in used:
            base += x["href"].split("/")[-1].split(".")[0]
        used.add((x["faction"], base.lower()))
        rel = vanilla_path(game_path(LINKS, "Heroes", x["faction"], base + ".(AdvMapObjectLink).xdb"))
        if args.dry_run:
            print("  ", rel[len(LINKS) + 1:], "<-", x["href"].split("#")[0])
        icon_rel = game_path("Heroes", x["faction"], base + ".tga")
        image = src.texture(href(x["xml"], "FaceTexture"), (128, 128))
        if image is not None:
            out.icon(icon_rel, image)
        else:
            print("no portrait for", x["href"])
        icon = "Icons\\Generated\\MapObjects\\_(AdvMapObjectLink)\\" + icon_rel.replace("/", "\\") if image is not None else ""
        out.text(rel, link_xdb(link=x["href"], icon=icon))
        written.add(rel.lower())

    # Hide every other link of both folders (vanilla files and older mod files)
    hidden_count = out.hide_others(src, FOLDERS, written)
    print(f"{len(heroes)} heroes, 16 classes, {hidden_count} hidden links, "
          f"{out.written} files {'to write' if args.dry_run else 'written'}")


if __name__ == "__main__":
    main()
