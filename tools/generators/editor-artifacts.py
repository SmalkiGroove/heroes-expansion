"""Map editor artifact palette: one link per placeable artifact of Artifacts.xdb.

The editor's "Artifacts" category is the folder MapObjects/_(AdvMapObjectLink)/Artifacts/
(editor/editor/MapFilters.xml). A link only shows once it is listed in core/index.bin, and
HideInEditor hides it even when listed.

An artifact gets a link when its table entry has a map object (ArtifactShared, not the XXX
placeholder), is not in the INVENTORY slot (except the grail) and is not excluded below.

Writes, in game_data/artifacts/MapObjects/_(AdvMapObjectLink)/Artifacts:
  <Name>.(AdvMapObjectLink).xdb    one link per artifact, <Name> = its text folder (/Text/Game/Artifacts/<Name>/)
  hidden overrides (HideInEditor true) for every other vanilla or mod link of the folder, except the
  random artifacts (Random-*.xdb)
and the artifact icons in editor/Complete/Icons/Generated/MapObjects/_(AdvMapObjectLink)/Artifacts/.

Then add new links to core/index.bin (H5X_DLL tools/h5index/h5index.py update --links-under
"/MapObjects/_(AdvMapObjectLink)/Artifacts/"), sync artifacts, core and editor, and delete the cached
icons of changed links in H5Xdev/editor/IconCache/AdvMapObjectLink/MapObjects/_(AdvMapObjectLink)/Artifacts.
Never delete the whole IconCache: the vanilla icons are lost.
"""

import argparse
import os
import re

from editor_links import GAME_DATA, LINKS, Sources, Writer, game_path, href, link_xdb, same_case

ARTIFACTS = os.path.join(GAME_DATA, "artifacts")
TABLE = "/GameMechanics/RefTables/Artifacts.xdb"
FOLDER = "Artifacts"

# Artifacts with a map object that must not be placed from the editor
EXCLUDED_PREFIXES = ("POTION_",)
# Links kept as they are: the random artifacts
KEEP = ("Random-Any.xdb", "Random-Major.xdb", "Random-Minor.xdb", "Random-Relic.xdb")
# Link files that keep a vanilla name: already in the index, and a second link would show twice
LINK_FILES = {"GRAAL": "Graal.xdb"}


def table(src):
    xml = re.sub(r"<!--.*?-->", "", src.read(TABLE).decode("utf-8"), flags=re.S)
    for m in re.finditer(r"<Item>\s*<ID>([^<]*)</ID>\s*<obj>(.*?)</obj>", xml, re.S):
        body = m.group(2)
        name_ref = href(body, "NameFileRef") or ""
        yield dict(id=m.group(1), body=body, shared=href(body, "ArtifactShared") or "",
                   name=name_ref.split("/")[4] if name_ref.count("/") > 4 else "",
                   slot=re.search(r"<Slot>([^<]*)", body).group(1), type=re.search(r"<Type>([^<]*)", body).group(1))


def placeable(a):
    if not a["shared"] or not a["name"] or a["shared"].split("#")[0].split("/")[-1].startswith("XXX."):
        return False
    if a["slot"] == "INVENTORY" and a["type"] != "ARTF_CLASS_GRAIL":
        return False
    return not a["id"].startswith(EXCLUDED_PREFIXES)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true", help="print what would be written, write nothing")
    args = parser.parse_args()
    src, out = Sources(), Writer(ARTIFACTS, args.dry_run)
    vanilla_path = same_case(src, (FOLDER,))

    written, shared_done, count = set(), set(), 0
    for a in table(src):
        if not placeable(a) or a["shared"].lower() in shared_done:
            continue
        shared_done.add(a["shared"].lower())
        rel = vanilla_path(game_path(LINKS, FOLDER, LINK_FILES.get(a["id"], a["name"] + ".(AdvMapObjectLink).xdb")))
        icon_rel = game_path(FOLDER, a["name"] + ".tga")
        image = src.texture(href(a["body"], "Icon"))
        if image is not None:
            out.icon(icon_rel, image)
        else:
            print("no icon for", a["id"])
        icon = "Icons/Generated/MapObjects/_(AdvMapObjectLink)/" + icon_rel if image is not None else ""
        link = a["shared"] if "#" in a["shared"] else a["shared"] + "#xpointer(/AdvMapArtifactShared)"
        out.text(rel, link_xdb(link=link, icon=icon))
        written.add(rel.lower())
        count += 1

    keep = {game_path(LINKS, FOLDER, k).lower() for k in KEEP}
    hidden_count = out.hide_others(src, (FOLDER,), written, keep)
    for rel in out.created:
        print("new file:", rel)
    print(f"{count} artifacts, {hidden_count} hidden links, {out.written} files and {out.icons_written} icons "
          f"{'to write' if args.dry_run else 'written'}")


if __name__ == "__main__":
    main()
