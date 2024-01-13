import os
import xmltodict

data_path = "../../game_data/data"
visuals_path = "../../game_data/visuals"

artifact_file_path = "/GameMechanics/RefTables/Artifacts.xdb"

with open(os.path.join(data_path, artifact_file_path), 'r') as artifacts_file:
    artifacts_data = xmltodict.parse(artifacts_file.read())

for artifact in artifacts_data["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
    id = artifact["ID"]
    texture = artifact["obj"]["Icon"]
    mapobject = artifact["obj"]["ArtifactShared"]
    
