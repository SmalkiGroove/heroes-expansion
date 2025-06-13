from wand.image import Image
import os

def fix_image_encoding(image_path):
    with Image(filename=image_path) as img:
        img.options['dds:mipmaps'] = '0'
        img.save(filename=image_path)

interface_path = "../../game_data/interface/UI/pwlscreen"

for root, subdir, files in os.walk(interface_path):
    for file in files:
        if file.endswith(".dds"):
            file_path = os.path.join(root, file)
            fix_image_encoding(file_path)
            # exit()
