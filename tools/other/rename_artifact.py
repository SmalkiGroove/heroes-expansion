import os
import xmltodict

data_path = "../../game_data/data"
visuals_path = "../../game_data/visuals"

artifact_file_path = "/GameMechanics/RefTables/Artifacts.xdb"

excluded_ids = ["ARTIFACT_NONE", "GRAAL", "ARTIFACT_PRINCESS", "ARTIFACT_FREIDA"]

def id_to_name(id):
    name = str("")
    cap = True
    for c in str(id):
        if c == '_':
            cap = True
        else:
            if cap:
                name = name + c
                cap = False
            else:
                name = name + c.lower()


with open(os.path.join(data_path, artifact_file_path), 'r') as artifacts_file:
    artifacts_file_content = artifacts_file.read()
    artifacts_data = xmltodict.parse(artifacts_file_content)

artifacts_file = open(os.path.join(data_path, artifact_file_path), 'w')

for artifact in artifacts_data["Table_DBArtifact_ArtifactEffect"]["objects"]["Item"]:
    id = artifact["ID"]
    if id in excluded_ids:
        continue
    name = id_to_name(id)
    mapobject_file = str(artifact["obj"]["ArtifactShared"]["href"]).replace("#xpointer(/AdvMapArtifactShared)","")
    texture_file = str(artifact["obj"]["Icon"]["href"]).replace("#xpointer(/Texture)","")
    texture_file_dds = texture_file.replace(".xdb",".dds")
    artifacts_file_content.replace(f'<NameFileRef href="{artifact["obj"]["NameFileRef"]["href"]}"/>', f'<NameFileRef href="/Text/Game/Artifacts/{name}/Name.txt"/>')
    artifacts_file_content.replace(f'<DescriptionFileRef href="{artifact["obj"]["DescriptionFileRef"]["href"]}"/>', f'<DescriptionFileRef href="/Text/Game/Artifacts/{name}/Description.txt"/>')
    artifacts_file_content.replace(f'<Icon href="{artifact["obj"]["Icon"]["href"]}"/>', f'<Icon href="/Textures/HeroScreen/Artifacts/{name}.xdb#xpointer(/Texture)"/>')
    artifacts_file_content.replace(f'<ArtifactShared href="{artifact["obj"]["ArtifactShared"]["href"]}"/>', f'<ArtifactShared href="/MapObjects/Artifacts/{name}.(AdvMapArtifactShared).xdb#xpointer(/AdvMapArtifactShared)"/>')
    with open(os.path.join(data_path, mapobject_file), 'r+') as f:
        file_content = f.read()
        file_data = xmltodict.parse(file_content)
        file_content.replace(file_data["AdvMapArtifactShared"]["messagesFileRef"]["Item"][0], f'/Text/Game/Artifacts/{name}/Name.txt')
        file_content.replace(file_data["AdvMapArtifactShared"]["messagesFileRef"]["Item"][1], f'/Text/Game/Artifacts/{name}/Description.txt')
        f.write(file_content)
    os.rename(os.path.join(data_path, mapobject_file), os.path.join(data_path, f'/MapObjects/Artifacts/{name}.(AdvMapArtifactShared).xdb'))
    with open(os.path.join(visuals_path, texture_file), 'r+') as f:
        file_content = f.read()
        dest_file = xmltodict.parse(file_content)["Texture"]["DestName"]["href"]
        file_content.replace(f'<DestName href="{dest_file}"/>', f'<DestName href="{name}.dds"/>')
        f.write(file_content)
    os.rename(os.path.join(visuals_path, texture_file), os.path.join(visuals_path, f'/Textures/HeroScreen/Artifacts/{name}.xdb'))
    os.rename(os.path.join(visuals_path, texture_file_dds), os.path.join(visuals_path, f'/Textures/HeroScreen/Artifacts/{name}.dds'))
    break
