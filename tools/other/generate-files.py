import os
import xmltodict

data_path = "../../game_data/data"
artifact_file_path = "GameMechanics/RefTables/Artifacts.xdb"
advmaplink_path = "MapObjects/_(AdvMapObjectLink)/Artifacts"

with open(os.path.join(data_path, artifact_file_path), 'r') as artifacts_file:
    artifacts_file_content = artifacts_file.read()
    artifacts_data = xmltodict.parse(artifacts_file_content)

for artifact in artifacts_data["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
    mapobject_file = str(artifact["obj"]["ArtifactShared"]["@href"])
    texture_file = str(artifact["obj"]["Icon"]["@href"])
    with open(os.path.join(data_path, artifact_file_path), 'w') as advmaplink_file:
        advmaplink_file.write()
