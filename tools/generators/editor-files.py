import os
import xmltodict
from PIL import Image

editor_files = "../../editor/Complete/Icons/Generated/MapObjects/_(AdvMapObjectLink)"

path_to_artifacts = "../../game_data/artifacts"

def icon_artifact(name, path):
    print(f"Generating artifact {name}")
    icon = Image.open(os.path.join(path_to_artifacts, path))
    tga_path = path.replace('.dds', '.tga')
    icon.save(os.path.join(editor_files, "Artifacts", f"{name}.tga"))

with open(os.path.join(path_to_artifacts, "GameMechanics/RefTables/Artifacts.xdb")) as f_artifacts:
    artifacts = xmltodict.parse(f_artifacts.read())
    for artifact in artifacts["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
        if artifact["ID"] != "ARTIFACT_NONE":
            if artifact["obj"]["Slot"] != "INVENTORY":
                artifact_name = str(artifact["obj"]["NameFileRef"]["@href"]).split("/")[4]
                icon_path = str(artifact["obj"]["Icon"]["@href"])[1:-22] + "dds"
                icon_artifact(artifact_name, icon_path)
            

