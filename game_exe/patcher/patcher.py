import sys
import os
import yaml

if len(sys.argv) == 4:
    action = sys.argv[1]
    binary = sys.argv[2]
    path = sys.argv[3]
    if not (action == "apply" or action == "revert"):
        print(f"Argument 1 should be 'apply' or 'revert'. Got '{action}'.")
    if not os.path.exists(binary) or not os.path.isfile(binary):
        print(f"Argument 2 should be a valid file path. Got '{binary}'.")
        sys.exit(1)
    if not os.path.exists(path) or not os.path.isfile(path):
        print(f"Argument 3 should be a valid file path. Got '{path}'.")
        sys.exit(1)
else:
    print("Script requires 3 arguments. Example: 'patcher.py apply path/to/binary path/to/patch'.")
    sys.exit(1)

binary = os.path.abspath(binary)
path = os.path.abspath(path)

with open(path, 'r') as f:
    try:
        patch = yaml.safe_load(f)
        for c in patch['edits']:
            check = c['address']
            check = c['size']
            check = c['original']
            check = c['modified']
    except:
        print(f"Patch file '{sys.argv[3]}' is not a valid YAML file.")
        sys.exit(1)

print(f"Files validation successful. Starting to {action} patch '{sys.argv[3]}' on binary file '{sys.argv[2]}'.")

def execute(address:int, size:int, before:bytes, after:bytes):
    with open(binary, 'r+b') as bin:
        bin.seek(address)
        current = bin.read(size)
        if current == before:
            bin.seek(address)
            bin.write(after)
            print("Patch applied successfully.")
        elif current == after:
            print("Patch is already applied.")
        else:
            print(f"Unexpected value '{current}' at address '{address}'. Patch aborted.")

