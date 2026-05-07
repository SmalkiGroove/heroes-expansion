import os
import xmltodict
import fileinput
from jinja2 import Environment, FileSystemLoader

root_path = "../../game_data/artifacts"
artifact_file_path = "GameMechanics/RefTables/Artifacts.xdb"
advmaplink_path = "MapObjects/_(AdvMapObjectLink)/Artifacts"
editor_icons = "Icons/Generated/MapObjects/_(AdvMapObjectLink)/Artifacts"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates"))
advmaplink_tpl = jinja_env.get_template("AdvMapObjectLink.j2")
def write_from_template(path, variables):
    rendered = advmaplink_tpl.render(variables)
    with open(path, 'w') as out_file:
        out_file.write(rendered)


with open(os.path.join(root_path, artifact_file_path), 'r') as artifacts_file:
    artifacts_file_content = artifacts_file.read()
    artifacts_data = xmltodict.parse(artifacts_file_content)

tmp_dict = {
    'ARTF_CLASS_GRAIL': '',
    'ARTF_CLASS_MINOR': '/Effects/_(Effect)/ResoursesAndChests/Chest.xdb#xpointer(/Effect)',
    'ARTF_CLASS_MAJOR': '/Effects/_(Effect)/Artefacts/TomeOfLightMagicSun.(Effect).xdb#xpointer(/Effect)',
    'ARTF_CLASS_RELIC': '/Effects/_(Effect)/Artefacts/General/Gold.xdb#xpointer(/Effect)',
}

artifactshared = {
    'MINOR':{},
    'MAJOR':{},
    'RELIC':{},
}

for artifact in artifacts_data["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
    if artifact["ID"] != "ARTIFACT_NONE":
        artifact_name = str(artifact["obj"]["NameFileRef"]["@href"]).split("/")[4]
        mapobj_artifact_path = str(artifact["obj"]["ArtifactShared"]["@href"]).split('#')[0]
        # print(root_path + mapobj_artifact_path)
        for line in fileinput.input(root_path + mapobj_artifact_path, inplace=True):
            if line.find('<Effect href=') > -1:
                print(f'	<Effect href="{tmp_dict[str(artifact["obj"]["Type"])]}"/>')
            elif line.find('<ArtifactID>') > -1:
                print(f'	<ArtifactID>{str(artifact["ID"])}</ArtifactID>')
            else:
                print(line, end='')

        for artifact_class in artifactshared.keys():
            if artifact["obj"]["Type"] == f"ARTF_CLASS_{artifact_class}":
                mapobject_file = str(artifact["obj"]["ArtifactShared"]["@href"])
                artifactshared[artifact_class][artifact["ID"]] = f"    <Item href=\"{mapobject_file}\"/>"

        # advmaplink_file = os.path.join(root_path, advmaplink_path, f"{artifact_name}.xdb")
        # write_from_template(advmaplink_file, {'mapobject': mapobj_artifact_path, 'icon': f"{editor_icons}/{artifact_name}.tga"})

for artifact_class in artifactshared.keys():
    print(f"{artifact_class} artifacts :")
    for line in artifactshared[artifact_class].values():
        print(line)
