import sys
import os
import re

if len(sys.argv) != 2:
    print("Script requires 1 arguments. Example: 'translate-patch.py path/to/patch.yml'.")
    sys.exit(1)
else:
    path = sys.argv[1]
    if not os.path.exists(path) or not os.path.isfile(path):
        print(f"Argument should be a valid file path. Got '{path}'.")
        sys.exit(1)

pattern_comment = re.compile("[ ]*#.*\n")
pattern_address = re.compile("patchAddress:[ ]*([A-F0-9]+)")
pattern_originalv = re.compile("originalValue:[ ]*(.*)")
pattern_originalb = re.compile("originalBytes:[ ]*([A-F0-9 ]+)")
pattern_modifiedv = re.compile("patchValue:[ ]*(.*)")
pattern_modifiedb = re.compile("patchBytes:[ ]*([A-F0-9 ]+)")
pattern_valuetype = re.compile("valueType:[ ]*([A-Za-z]+)")

with open(path, 'r') as f:
    content = f.read()

content = re.sub(pattern_comment, "", content)
content = content.split("---")

definitons = None
edits_editor = []
edits_toe = []
edits_qai = []

for patch in content:
    if "definitions:" in patch:
        definitons = patch
    elif "group: Original" in patch:
        edits_toe.append(patch)
    elif "group: Quantomas3.1j" in patch:
        edits_qai.append(patch)
    elif "group: MapEditorOriginal" in patch:
        edits_editor.append(patch)
    else:
        print("Invalid YAML block :")
        print(patch)
        sys.exit(1)
del content

h5m_file = path.replace("patches_deflaktor", "patches\\h5toe").replace(os.path.basename(path), "h5m_" + os.path.basename(path))
h5s_file = path.replace("patches_deflaktor", "patches\\h5qai").replace(os.path.basename(path), "h5s_" + os.path.basename(path))
h5e_file = path.replace("patches_deflaktor", "patches\\h5qeditor").replace(os.path.basename(path), "h5e_" + os.path.basename(path))

def get_size_type(t):
    type = str(t).lower()
    if type == 'byte':
        return 1
    if type == 'short':
        return 2
    if type == 'integer':
        return 4
    if type == 'float':
        return 4
    if type == 'long':
        return 8
    if type == 'double':
        return 8
    return 0
def get_size_hex(h):
    hex = str(h).replace(" ","")
    n = len(hex)
    if n % 2:
        return int(0.5 * n)
    else:
        print(f"WARN: hex string '{h}' has odd number of characters.")
        return int(0.5 * (n+1))
    
def write_patch(f, edits):
    f.write("# Description\n")
    if definitons != None:
        f.write(definitons)
    f.write("edits:\n")
    i = 1
    for edit in edits:
        if re.search(pattern_valuetype, edit):
            type = re.search(pattern_valuetype, edit).group(1)
            original = re.search(pattern_originalv, edit).group(1)
            modified = re.search(pattern_modifiedv, edit).group(1)
        else:
            type = None
            original = re.search(pattern_originalb, edit).group(1)
            modified = re.search(pattern_modifiedb, edit).group(1)
        size = get_size_type(type) if type != None else get_size_hex(original)
        type = "int" if type != None else "hex"
        q = "" if type != None else "'"
        address = re.search(pattern_address, edit).group(1)
        f.write(f"  - name: Edit {i}\n")
        f.write(f"    address: '{address}'\n")
        f.write(f"    size: {size}\n")
        f.write(f"    type: {type}\n")
        f.write(f"    original: {q}{original}{q}\n")
        f.write(f"    modified: {q}{modified}{q}\n")
        i = i + 1

if len(edits_toe) > 0:
    with open(h5m_file, 'w') as f:
        write_patch(f, edits_toe)
if len(edits_qai) > 0:
    with open(h5s_file, 'w') as f:
        write_patch(f, edits_qai)
if len(edits_editor) > 0:
    with open(h5e_file, 'w') as f:
        write_patch(f, edits_editor)
