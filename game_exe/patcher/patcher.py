import sys
import os
import yaml

if len(sys.argv) != 4:
    print("Script requires 3 arguments. Example: 'patcher.py apply path/to/binary path/to/patch'.")
    sys.exit(1)
else:
    action = sys.argv[1]
    binary = sys.argv[2]
    path = sys.argv[3]
    if not (action == "apply" or action == "revert"):
        print(f"Argument 1 should be 'apply' or 'revert'. Got '{action}'.")
        sys.exit(1)
    if not os.path.exists(binary) or not os.path.isfile(binary):
        print(f"Argument 2 should be a valid file path. Got '{binary}'.")
        sys.exit(1)
    if not os.path.exists(path) or not os.path.isfile(path):
        print(f"Argument 3 should be a valid file path. Got '{path}'.")
        sys.exit(1)

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
            if not (type == 'int' or type == 'hex'):
                raise ValueError()
            check = int(c['original']) if type == 'int' else bytes.fromhex(c['original'])
            check = int(c['modified']) if type == 'int' else bytes.fromhex(c['modified'])
    except:
        print(f"Patch file '{os.path.basename(path)}' is not a valid patch file.")
        sys.exit(1)


print(f"Files validation successful. Starting to {action} patch '{os.path.basename(path)}' on binary file '{os.path.basename(binary)}'.")

def execute(name:str, address:int, size:int, before:bytes, after:bytes):
    with open(binary, 'r+b') as bin:
        bin.seek(address)
        current = bin.read(size)
        if current == before:
            bin.seek(address)
            bin.write(after)
            print(f"Patch '{name}' applied successfully.")
        elif current == after:
            print(f"Patch '{name}' is already applied.")
        else:
            print(f"Unexpected value '{current}' at address '{address}'.")
            print(f"Patch '{name}' failed. Aborting.")
            sys.exit(1)

for c in patch['edits']:
    name = str(c['name'])
    address = int(c['address'], 16)
    size = int(c['size'])
    type = str(c['type'])
    original = int(c['original']).to_bytes(size, 'little') if type == 'int' else bytes.fromhex(str(c['original']))
    modified = int(c['modified']).to_bytes(size, 'little') if type == 'int' else bytes.fromhex(str(c['modified']))
    before = original if action == 'apply' else modified
    after = modified if action == 'apply' else original
    execute(name, address, size, before, after)
