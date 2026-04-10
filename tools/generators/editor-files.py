import os
import xmltodict
from PIL import Image

ENABLE_ARTIFACTS = False
ENABLE_CREATURES = True

editor_files = "../../editor/Complete/Icons/Generated/MapObjects/_(AdvMapObjectLink)"

path_to_artifacts = "../../game_data/artifacts"
path_to_creatures = "../../game_data/creatures"

def icon_artifact(name, path):
    print(f"Generating artifact {name}")
    icon = Image.open(os.path.join(path_to_artifacts, path))
    tga_path = path.replace('.dds', '.tga')
    icon.save(os.path.join(editor_files, "Artifacts", f"{name}.tga"))

def icon_creature(name, path):
    print(f"Generating creature {name}")
    icon = Image.open(os.path.join(path_to_creatures, path))
    tga_path = path.replace('.dds', '.tga')
    icon.save(os.path.join(editor_files, "Monsters", f"{name}.tga"))

if ENABLE_ARTIFACTS:
    with open(os.path.join(path_to_artifacts, "GameMechanics/RefTables/Artifacts.xdb")) as f_artifacts:
        artifacts = xmltodict.parse(f_artifacts.read())
        for artifact in artifacts["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
            if artifact["ID"] != "ARTIFACT_NONE":
                if artifact["obj"]["Slot"] != "INVENTORY":
                    artifact_name = str(artifact["obj"]["NameFileRef"]["@href"]).split("/")[4]
                    icon_path = str(artifact["obj"]["Icon"]["@href"])[1:-22] + "dds"
                    icon_artifact(artifact_name, icon_path)
            
if ENABLE_CREATURES:
    for path, dirs, files in os.walk(os.path.join(path_to_creatures, "MapObjects/_(AdvMapObjectLink)/Monsters")):
        for file in files:
            with open(os.path.join(path, file)) as f_monster_link:
                monster_link = xmltodict.parse(f_monster_link.read())
            if monster_link["AdvMapObjectLink"]["Link"] is not None:
                monster_shared_path = monster_link["AdvMapObjectLink"]["Link"]["@href"][1:-31]
                with open(os.path.join(path_to_creatures, monster_shared_path)) as f_monster_shared:
                    monster_shared = xmltodict.parse(f_monster_shared.read())
                monster_name = str(monster_shared["AdvMapMonsterShared"]["messagesFileRef"]["Item"]["@href"]).split("/")[5]
                icon_path = monster_shared["AdvMapMonsterShared"]["Icon128"]["@href"][1:-22] + "dds"
                icon_creature(monster_name, icon_path)

