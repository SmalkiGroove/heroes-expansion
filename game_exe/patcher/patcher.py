import sys
import os
import yaml
import struct

if len(sys.argv) != 4:
    print("Script requires 3 arguments. Example: 'patcher.py apply path/to/binary path/to/patch'.")
    sys.exit(1)
else:
    action = sys.argv[1]
    binary = sys.argv[2]
    path = sys.argv[3]
    if not (action == "apply" or action == "revert" or action == "check"):
        print(f"Argument 1 should be 'apply' or 'revert'. Got '{action}'.")
        sys.exit(1)
    if not os.path.exists(binary) or not os.path.isfile(binary):
        print(f"Argument 2 should be a valid file path. Got '{binary}'.")
        sys.exit(1)
    if not os.path.exists(path) or not os.path.isfile(path):
        print(f"Argument 3 should be a valid file path. Got '{path}'.")
        sys.exit(1)

print(f"> {action} patch '{os.path.basename(path)}' on binary file '{os.path.basename(binary)}'.")

binary = os.path.abspath(binary)
path = os.path.abspath(path)

with open(path, 'r') as f:
    try:
        patch = yaml.safe_load(f)
        for c in patch['edits']:
            check = str(c['name'])
            check = int(c['address'], 16)
            check = int(c['size'])
            type = str(c['type'])
            if not (type == 'hex' or type == 'int' or type == 'float'):
                raise ValueError()
            check = bytes.fromhex(c['original']) if type == 'hex' else int(c['original']) if type == 'int' else float(c['original'])
            check = bytes.fromhex(c['modified']) if type == 'hex' else int(c['modified']) if type == 'int' else float(c['modified'])
    except:
        print(f"Patch file '{os.path.basename(path)}' is not a valid patch file.")
        sys.exit(1)

print("Patch file validation successful.")

def execute(name:str, address:int, size:int, before:bytes, after:bytes):
    with open(binary, 'r+b') as bin:
        bin.seek(address)
        current = bin.read(size)
        if current == after:
            print(f"Patch already applied : '{name}'")
        elif current == before:
            if action != "check":
                bin.seek(address)
                bin.write(after)
            print(f"Patch applied successfully : '{name}'")
        else:
            if action == "revert":
                bin.seek(address)
                bin.write(after)
                print(f"Patch applied successfully : '{name}'")
            else:
                print(f"Unexpected value {current} at address '{hex(address)}'. Should be {before}.")
                if action == "apply":
                    print(f"Patch '{name}' failed. Aborting.")
                    sys.exit(1)

for c in patch['edits']:
    name = str(c['name'])
    address = int(c['address'], 16)
    size = int(c['size'])
    type = str(c['type'])
    original = bytes.fromhex(str(c['original'])) if type == 'hex' else int(c['original']).to_bytes(size, 'little') if type == 'int' else struct.pack('<f', float(c['original']))
    modified = bytes.fromhex(str(c['modified'])) if type == 'hex' else int(c['modified']).to_bytes(size, 'little') if type == 'int' else struct.pack('<f', float(c['modified']))
    before = modified if action == 'revert' else original
    after = original if action == 'revert' else modified
    execute(name, address, size, before, after)
