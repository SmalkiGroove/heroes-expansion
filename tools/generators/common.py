"""Shared helpers for the encyclopedia (www-*) generators."""

import argparse
import os
import shutil
import xmltodict
from jinja2 import Environment, FileSystemLoader

GENERATORS_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(os.path.dirname(GENERATORS_DIR))
GAME_DATA = os.path.join(REPO_ROOT, "game_data")
TEXTS_EN = os.path.join(REPO_ROOT, "game_texts", "texts-EN")

# Generated files keep the CRLF line endings of the committed files, whatever the OS
NEWLINE = "\r\n"


class Generator:
    """Renders Jinja2 templates into .xdb files, honouring --dry-run and --debug."""

    def __init__(self, templates_dir, description):
        parser = argparse.ArgumentParser(description=description)
        parser.add_argument("--dry-run", action="store_true", help="render everything but write no file")
        parser.add_argument("--debug", action="store_true", help="print extra details")
        args = parser.parse_args()
        self.dry_run = args.dry_run
        self.debug = args.debug
        self.env = Environment(loader=FileSystemLoader(searchpath=os.path.join(GENERATORS_DIR, templates_dir)))
        self.written = 0
        self.outputs = set()

    def write(self, tpl_name, output_path, variables):
        rendered = self.env.get_template(tpl_name).render(variables)
        self.written += 1
        self.outputs.add(os.path.normcase(os.path.abspath(output_path)))
        if not self.dry_run:
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            with open(output_path, 'w', encoding="utf-8", newline=NEWLINE) as out_file:
                out_file.write(rendered)

    def write_text(self, output_path, content):
        """Writes a game text file (UTF-16 LE with BOM)."""
        self.outputs.add(os.path.normcase(os.path.abspath(output_path)))
        if not self.dry_run:
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            with open(output_path, 'w', encoding="utf-16") as out_file:
                out_file.write(content)

    def prune(self, path):
        """Removes a stale generated file or folder (one the current data no longer produces)."""
        print(f"Remove stale {os.path.relpath(path, REPO_ROOT)}")
        if not self.dry_run:
            if os.path.isdir(path):
                shutil.rmtree(path)
            else:
                os.remove(path)

    def prune_unwritten(self, root, keep=()):
        """Removes every file under root that this run did not write, except the hand-made ones.

        keep lists paths relative to root, with '/': a file is kept when its path starts with one of them.
        """
        for folder, _, files in os.walk(root, topdown=False):
            for file in files:
                path = os.path.join(folder, file)
                rel_path = os.path.relpath(path, root).replace('\\', '/')
                if os.path.normcase(os.path.abspath(path)) not in self.outputs and not rel_path.startswith(tuple(keep)):
                    self.prune(path)
            if folder != root and not self.dry_run and not os.listdir(folder):
                os.rmdir(folder)

    def log(self, msg):
        if self.debug:
            print(msg)


def warn(msg):
    print(f"WARN: {msg}")


def load_xdb(*path):
    with open(os.path.join(*path), 'r', encoding="utf-8") as xdb_file:
        return xmltodict.parse(xdb_file.read())


def as_list(value):
    """xmltodict returns a dict for a single <Item>, a list for several and None for none."""
    if value is None:
        return []
    return value if isinstance(value, list) else [value]


def items(node):
    """The <Item> children of a node, as a list (empty when the node itself is empty)."""
    return as_list(node.get('Item')) if node else []


def href_path(href):
    """'/path/file.xdb#xpointer(/Type)' -> 'path/file.xdb' (relative to a data folder root)."""
    return href.split('#')[0].lstrip('/')


def game_path(*parts):
    """Joins a path of the game's virtual file system, always with forward slashes."""
    return '/' + '/'.join(p.replace('\\', '/').strip('/') for p in parts if p)


def texture_size(href, default=64):
    """Width of a texture of the mod, read from its (Texture).xdb in any data folder; default for vanilla ones."""
    path = href_path(href)
    for folder in sorted(os.listdir(GAME_DATA)):
        texture_file = os.path.join(GAME_DATA, folder, path)
        if os.path.isfile(texture_file):
            width = load_xdb(texture_file).get('Texture', {}).get('Width')
            return int(width) if width else default
    return default


def find_icon_size(path: str):
    """Native size (px) of an icon texture: H5A textures come in mixed sizes, vanilla ones are 64px."""
    if path.startswith("/UI/H5A"):
        if "128x128" in path:
            return 128
        elif "/Blood_Rage/" in path:
            if ("Perk_MightOverMagic" in path) or ("Perk_Memory_of_Our_Blood" in path):
                return 64
            else:
                return 128
        elif ("/Voice/" in path):
            if ("Perk_Voice_Training" in path) or ("Perk_Mighty_Voice" in path) or ("Perk_Voice_of_Rage" in path):
                return 128
            else:
                return 64
        elif ("Shatter_Light_Magic" in path) or ("Bodybuilding" in path) or ("Corrupt_Light" in path) or ("Path_of_War" in path):
            return 64
        else:
            return 128
    elif "LungWorkout" in path:
        return 128
    return 64
