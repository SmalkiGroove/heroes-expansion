import os
import xmltodict
import fileinput

data_path = "../../game_data/data"
artifact_file_path = "GameMechanics/RefTables/Artifacts.xdb"
# advmaplink_path = "MapObjects/_(AdvMapObjectLink)/Artifacts"

with open(os.path.join(data_path, artifact_file_path), 'r') as artifacts_file:
    artifacts_file_content = artifacts_file.read()
    artifacts_data = xmltodict.parse(artifacts_file_content)

tmp_dict = {
    'ARTF_CLASS_GRAIL': '',
    'ARTF_CLASS_MINOR': '',
    'ARTF_CLASS_MAJOR': '/Effects/_(Effect)/Artefacts/General/Blue.xdb#xpointer(/Effect)',
    'ARTF_CLASS_RELIC': '/Effects/_(Effect)/Artefacts/General/Red.xdb#xpointer(/Effect)',
}

for artifact in artifacts_data["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
    if artifact["ID"] != "ARTIFACT_NONE":
        mapobj_artifact_path = str(artifact["obj"]["ArtifactShared"]["@href"]).split('#')[0]
        print(data_path + mapobj_artifact_path)
        for line in fileinput.input(data_path + mapobj_artifact_path, inplace=True):
            if line.find('<Effect href=') > -1:
                print(f'	<Effect href="{tmp_dict[str(artifact["obj"]["Type"])]}"/>', end='')
            else:
                print(line, end='')

        # if artifact["obj"]["Type"] == "ARTF_CLASS_RELIC":
        #     mapobject_file = str(artifact["obj"]["ArtifactShared"]["@href"])
        #     print(f"	<Item href=\"{mapobject_file}\"/>")

        # texture_file = str(artifact["obj"]["Icon"]["@href"])
        # with open(os.path.join(data_path, artifact_file_path), 'w') as advmaplink_file:
        #     advmaplink_file.write()
