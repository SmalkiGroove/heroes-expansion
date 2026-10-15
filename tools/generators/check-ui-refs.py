"""Checks the encyclopedia (/UI/Doc) files of the www-* data folders for broken references.

- every href pointing into /UI/Doc must resolve to a file of one of the data folders, as the
  game merges all the paks into one virtual file system;
- every window shown or enabled by a UISSendUIMessage must have a matching <Name>.
References to other paths (vanilla files, texts) are not checked.
"""

import os
import re
import sys
from common import GAME_DATA, REPO_ROOT

href_regex = re.compile(r'href="([^"#]+)')
name_regex = re.compile(r'<Name>([^<]+)</Name>')
message_regex = re.compile(r'<szMessageID>\s*<First>(UI_SHOW_WINDOW|UI_ENABLE_WINDOW)</First>.*?<szParam>\s*<First>([^<]*)</First>', re.S)

data_roots = [os.path.join(GAME_DATA, folder) for folder in sorted(os.listdir(GAME_DATA)) if os.path.isdir(os.path.join(GAME_DATA, folder))]

def exists_in_game(virtual_path):
    return any(os.path.isfile(os.path.join(root, virtual_path.lstrip('/'))) for root in data_roots)

names = set()
messages = []
broken = []
checked = 0
for root in data_roots:
    if not os.path.basename(root).startswith("www"):
        continue
    for dirpath, _, files in os.walk(root):
        for file in files:
            if not file.endswith(".xdb"):
                continue
            path = os.path.join(dirpath, file)
            virtual_dir = '/' + os.path.relpath(dirpath, root).replace('\\', '/')
            with open(path, 'r', encoding="utf-8", errors="replace") as xdb_file:
                content = re.sub(r'<!--.*?-->', '', xdb_file.read(), flags=re.S)
            names.update(name_regex.findall(content))
            messages += [(path, msg, target) for msg, target in message_regex.findall(content)]
            for href in href_regex.findall(content):
                virtual = href if href.startswith('/') else os.path.normpath(os.path.join(virtual_dir, href)).replace('\\', '/')
                if virtual.startswith("/UI/Doc/"):
                    checked += 1
                    if not exists_in_game(virtual):
                        broken.append((path, href))

for path, href in broken:
    print(f"BROKEN: {os.path.relpath(path, REPO_ROOT)} -> {href}")
unknown = [(path, msg, target) for path, msg, target in messages if target not in names]
for path, msg, target in unknown:
    print(f"UNKNOWN WINDOW: {os.path.relpath(path, REPO_ROOT)} sends {msg} to '{target}'")
print(f"{checked} references and {len(messages)} window messages checked: {len(broken)} broken, {len(unknown)} unknown windows")
sys.exit(1 if broken or unknown else 0)
