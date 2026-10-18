"""Shared helpers for the map editor palette generators (editor-heroes.py, editor-artifacts.py).

The editor's object categories are folders of AdvMapObjectLink files, listed in
editor/editor/MapFilters.xml. A link shows once it is listed in core/index.bin; HideInEditor hides it
even when listed, so the generators hide every link of their folders they do not write.
"""

import glob
import io
import os
import re
import zipfile

from PIL import Image

GENERATORS_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(os.path.dirname(GENERATORS_DIR))
GAME_DATA = os.path.join(REPO_ROOT, "game_data")
TEXTS_EN = os.path.join(REPO_ROOT, "game_texts", "texts-EN")
ICONS = os.path.join(REPO_ROOT, "editor", "Complete", "Icons", "Generated", "MapObjects", "_(AdvMapObjectLink)")
GAME_FOLDER = os.environ.get("H5_Folder", r"G:\__H5__\H5Xdev")
NEWLINE = "\r\n"
LINKS = "MapObjects/_(AdvMapObjectLink)"


def game_path(*parts):
    return "/".join(p.strip("/") for p in parts)


class Sources:
    """Reads a game path from game_data, else from the vanilla paks."""

    def __init__(self):
        self.paks = {}
        for name in ("data.pak", "a2p1-data.pak", "texts.pak", "a2p1-texts.pak"):
            path = os.path.join(GAME_FOLDER, "data", name)
            if os.path.exists(path):
                z = zipfile.ZipFile(path)
                for n in z.namelist():
                    self.paks[n.lower()] = (z, n)

    def read(self, path, roots=None):
        path = path.split("#")[0].lstrip("/")
        for root in roots or [os.path.join(GAME_DATA, d) for d in os.listdir(GAME_DATA)]:
            f = os.path.join(root, *path.split("/"))
            if os.path.exists(f):
                return open(f, "rb").read()
        e = self.paks.get(path.lower())
        return e[0].read(e[1]) if e else None

    def text(self, path):
        """English text of a /Text/... reference, from texts-EN or the vanilla text paks."""
        data = self.read(path, [TEXTS_EN]) if path else None
        return data.decode("utf-16").strip() if data else None

    def vanilla(self, prefix):
        prefix = prefix.lower()
        return sorted({n for k, (z, n) in self.paks.items() if k.startswith(prefix) and k.endswith(".xdb")})

    def texture(self, ref, size=None):
        """RGBA image of a (Texture).xdb reference, read from its .dds next to it."""
        if not ref:
            return None
        data = self.read(ref.split("#")[0][:-len(".xdb")] + ".dds")
        if not data:
            return None
        image = Image.open(io.BytesIO(data)).convert("RGBA")
        return image if not size or image.size == size else image.resize(size, Image.LANCZOS)


def tag(xml, name):
    m = re.search(rf"<{name}>([^<]*)</{name}>", xml)
    return m.group(1) if m else None


def href(xml, name):
    m = re.search(rf'<{name} href="([^"]*)"', xml)
    return m.group(1) if m else None


def file_name(text):
    return re.sub(r"[^A-Za-z0-9]", "", text)


def link_xdb(link="", group="", icon="", hide=False):
    lines = ['<?xml version="1.0" encoding="UTF-8"?>', "<AdvMapObjectLink>",
             f'\t<Link href="{link}"/>' if link else "\t<Link/>",
             f'\t<RndGroup href="{group}"/>' if group else "\t<RndGroup/>",
             f"\t<IconFile>{icon}</IconFile>" if icon else "\t<IconFile/>",
             f"\t<HideInEditor>{'true' if hide else 'false'}</HideInEditor>", "</AdvMapObjectLink>", ""]
    return NEWLINE.join(lines)


def group_xdb(hrefs):
    lines = ['<?xml version="1.0" encoding="UTF-8"?>', "<AdvMapSharedGroup>", "\t<links>"]
    lines += [f'\t\t<Item href="{h}"/>' for h in hrefs]
    lines += ["\t</links>", "</AdvMapSharedGroup>", ""]
    return NEWLINE.join(lines)


def hidden(xml):
    """Same link with HideInEditor true."""
    if "<HideInEditor>" in xml:
        return re.sub(r"<HideInEditor>\w*</HideInEditor>", "<HideInEditor>true</HideInEditor>", xml)
    return xml.replace("</AdvMapObjectLink>", "\t<HideInEditor>true</HideInEditor>\r\n</AdvMapObjectLink>")


class Writer:
    """Writes game files into one game_data folder and icons into editor/Complete, unless dry_run."""

    def __init__(self, root, dry_run):
        self.root, self.dry_run, self.written, self.icons_written, self.created = root, dry_run, 0, 0, []

    def text(self, rel, content):
        path = os.path.join(self.root, *rel.split("/"))
        data = content.encode("utf-8")
        # Files written by hand often lack the final line break: not a change
        if os.path.exists(path) and open(path, "rb").read().rstrip(b"\r\n") == data.rstrip(b"\r\n"):
            return
        self.written += 1
        if not os.path.exists(path):
            self.created.append(rel)
        if not self.dry_run:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            open(path, "wb").write(data)

    def icon(self, rel, image):
        path = os.path.join(ICONS, *rel.split("/"))
        if os.path.exists(path):
            old = Image.open(path).convert("RGBA")
            if old.size == image.size and old.tobytes() == image.tobytes():
                return
        self.icons_written += 1
        if not self.dry_run:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            image.save(path)

    def hide_others(self, src, folders, written, keep=()):
        """Hides every vanilla or mod link of the folders that is not in `written` (lower-case game paths)."""
        others = set()
        for folder in folders:
            others |= set(src.vanilla(game_path(LINKS, folder) + "/"))
            for f in glob.glob(os.path.join(self.root, *LINKS.split("/"), folder, "**", "*.xdb"), recursive=True):
                others.add(os.path.relpath(f, self.root).replace(os.sep, "/"))
        count = 0
        for rel in sorted(others):
            if rel.lower() in written or rel.lower() in keep:
                continue
            xml = (src.read(rel, [self.root]) or src.read(rel)).decode("utf-8", "replace")
            if hidden(xml) != xml or os.path.exists(os.path.join(self.root, *rel.split("/"))):
                self.text(rel, hidden(xml))     # a vanilla link already hidden needs no override
            count += 1
        return count


def same_case(src, folders):
    """A link replacing a vanilla one keeps the vanilla spelling (Demonlord.xdb): the index lists that one."""
    vanilla_case = {p.lower(): p for folder in folders for p in src.vanilla(game_path(LINKS, folder) + "/")}
    return lambda rel: vanilla_case.get(rel.lower(), rel)
