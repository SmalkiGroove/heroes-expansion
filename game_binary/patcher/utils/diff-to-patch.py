import sys
import os
import yaml

if len(sys.argv) != 3:
    print("Script requires 2 arguments. Example: 'diff-to-patch.py path/to/binary1 path/to/binary2'.")
    sys.exit(1)
else:
    binary1 = sys.argv[1]
    binary2 = sys.argv[2]
    if not os.path.exists(binary1) or not os.path.isfile(binary1):
        print(f"Argument 2 should be a valid file path. Got '{binary1}'.")
        sys.exit(1)
    if not os.path.exists(binary2) or not os.path.isfile(binary2):
        print(f"Argument 3 should be a valid file path. Got '{binary2}'.")
        sys.exit(1)

print(f"> Compare files '{os.path.basename(binary1)}' and '{os.path.basename(binary2)}'.")

patch = {"edits": []}
def make_edit(offset:int, bytes1:bytearray, bytes2:bytearray):
    edit = {
        "name": "Unknown",
        "address": hex(offset),
        "size": len(bytes1),
        "type": "hex",
        "original": bytes1.hex(" ").upper(),
        "modified": bytes2.hex(" ").upper(),
    }
    patch["edits"].append(edit)

binary1 = os.path.abspath(binary1)
binary2 = os.path.abspath(binary2)

b1 = open(binary1, 'rb')
b2 = open(binary2, 'rb')

chain1:bytearray = None
chain2:bytearray = None
offset:int = 0
chain0:int = 0
broker:int = 0

while ((byte1 := b1.read(1)) and (byte2 := b2.read(1))):
    if byte1 == byte2:
        if chain1 is not None and len(chain1) > 0:
            broker = broker + 1
            if broker == 8:
                make_edit(chain0, chain1[:-7], chain2[:-7])
                chain1.clear()
                chain2.clear()
            else:
                chain1.append(byte1[0])
                chain2.append(byte2[0])
    else:
        broker = 0
        if chain1 is None or len(chain1) == 0:
            chain0 = offset
            chain1 = bytearray(byte1)
            chain2 = bytearray(byte2)
        else:
            chain1.append(byte1[0])
            chain2.append(byte2[0])
    
    offset += 1

b1.close()
b2.close()

out_file = "raw_patch.yml"
print(f"Done! Saving patch as {out_file}.")
with open(out_file, 'w') as f:
    yaml.dump(patch, f, sort_keys=False)
