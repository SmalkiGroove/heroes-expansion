import os
import zipfile

workdir = os.path.dirname(os.path.abspath(__file__))

print("=== UPDATE VERSION ===")

path_to_version_file = "../VERSION"
path_to_version_txt = "../game_data/texts/UI/MainMenu2/Version.txt"

with open(os.path.join(workdir, path_to_version_file), 'r') as version_file:
    version = version_file.read()

print(f"> current version : {version}")
version_txt = f"<h3_bright>H5X mod\nVersion {version}"

with open(os.path.join(workdir, path_to_version_txt), 'w') as version_file:
    version_file.write(version_txt)


pak_file = f"../h5x-{version}.pak"
lang_file = f"../h5x-{version}-texts-EN.pak"

game_data_path = "../game_data"
data_dirs = ["characters","data","doc","interface","lua","maps"]
text_dirs = ["texts"]

path_prefix = len(os.path.abspath(game_data_path)) + 1

print("=== CREATE PAK ===")
with zipfile.ZipFile(os.path.join(workdir, pak_file), 'w', zipfile.ZIP_DEFLATED) as pak:
    print(f"> root dir : {os.path.abspath(game_data_path)}")
    for datadir in data_dirs:
        datadir_prefix = path_prefix + len(datadir) + 1
        print(f"> add {datadir} in pak")
        for root, dirs, files in os.walk(os.path.join(workdir, game_data_path, datadir)):
            for file in files:
                    file_path = os.path.join(os.path.abspath(root), file)
                    arcname = file_path[datadir_prefix:]
                    pak.write(file_path, arcname=arcname)

for textdir in text_dirs:
    textdir_prefix =path_prefix + len(textdir) + 1
    with zipfile.ZipFile(os.path.join(workdir, lang_file), 'w', zipfile.ZIP_DEFLATED) as pak:
        print(f"> add {textdir} in pak")
        for root, dirs, files in os.walk(os.path.join(workdir, game_data_path, textdir)):
            for file in files:
                    file_path = os.path.join(os.path.abspath(root), file)
                    arcname = file_path[textdir_prefix:]
                    pak.write(file_path, arcname=arcname)
