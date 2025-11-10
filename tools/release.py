import os
import zipfile
import semver

BUMP = 'm' # M.m.p

workdir = os.path.dirname(os.path.abspath(__file__))

print("=== UPDATE VERSION ===")

path_to_version_file = "../VERSION"
path_to_version_txt = "../game_data/data/UI/MainMenu2/Version.txt"

with open(os.path.join(workdir, path_to_version_file), 'r') as version_file:
    version = version_file.read()

print(f"> current version : {version}")
semversion = semver.Version.parse(version)
if BUMP == 'M':
    semversion = semversion.bump_major()
elif BUMP == 'm':
    semversion = semversion.bump_minor()
elif BUMP == 'p':
    semversion = semversion.bump_patch()
version = str(semversion)
print(f"> release version : {version}")

version_txt = f"<h3_bright>H5X mod\nVersion {version}"

with open(os.path.join(workdir, path_to_version_file), 'w') as version_file:
    version_file.write(version)
with open(os.path.join(workdir, path_to_version_txt), 'w', encoding='utf-16-LE') as version_file:
    version_file.write(u'\ufeff')
    version_file.write(version_txt)

# exit()
pak_file = f"../h5x-{version}.pak"

game_data_path = "../game_data"
data_dirs = ["characters","data","interface","lua","maps","visuals","doc", "doc-artifacts","doc-creatures","doc-heroes","doc-skills"]

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

game_texts_path = "../game_texts"
text_dirs = ["texts-EN"]

for textdir in text_dirs:
    lang_file = f"../h5x-{version}-{textdir}.pak"
    textdir_prefix = path_prefix + len(textdir) + 1
    with zipfile.ZipFile(os.path.join(workdir, lang_file), 'w', zipfile.ZIP_DEFLATED) as pak:
        print(f"> add {textdir} in pak")
        for root, dirs, files in os.walk(os.path.join(workdir, game_texts_path, textdir)):
            for file in files:
                    file_path = os.path.join(os.path.abspath(root), file)
                    arcname = file_path[textdir_prefix:]
                    pak.write(file_path, arcname=arcname)
