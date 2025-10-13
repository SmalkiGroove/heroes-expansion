
import os
import xmltodict
from jinja2 import Environment, FileSystemLoader

root_text_path = "../../game_texts/texts-EN"
skills_xdb_path = "../../game_data/data/GameMechanics/RefTables/Skills.xdb"
skills_pedia_path = "../../game_data/doc-skills/UI/Doc/Skills"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates-skills"))

with open(skills_xdb_path, 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())

all_buttons = open("outputs/skills_skillbuttons.xml", 'w')
all_selected = open("outputs/skills_selectionhighlights.xml", 'w')
all_windows = open("outputs/skills_descriptionviews.xml", 'w')

coordinates_branch = [
    [0, 140], [190, 140], [380, 140],
    [0, 220], [190, 220], [380, 220],
    [0, 300], [190, 300], [380, 300],
    [0, 380], [190, 380], [380, 380],
    [0, 460], [190, 460], [380, 460],
]

coordinates_skills = {
  '001001': [45, 10],
  '001002': [75, 10],
  '001003': [105, 10],
  '002001': [45, 10],
  '002002': [75, 10],
  '002003': [105, 10],
  '003001': [45, 10],
  '003002': [75, 10],
  '003003': [105, 10],
  '004000': [100, 45],
  '005000': [125, 45],
  '006001': [45, 10],
  '006002': [75, 10],
  '006003': [105, 10],
  '007001': [45, 10],
  '007002': [75, 10],
  '007003': [105, 10],
  '008001': [45, 10],
  '008002': [75, 10],
  '008003': [105, 10],
  '009001': [45, 10],
  '009002': [75, 10],
  '009003': [105, 10],
  '010001': [45, 10],
  '010002': [75, 10],
  '010003': [105, 10],
  '011001': [45, 10],
  '011002': [75, 10],
  '011003': [105, 10],
  '012001': [45, 10],
  '012002': [75, 10],
  '012003': [105, 10],
  '013001': [45, 10],
  '013002': [75, 10],
  '013003': [105, 10],
  '014001': [220, 26],
  '014002': [250, 26],
  '014003': [280, 26],
  '014004': [310, 26],
  '015001': [220, 26],
  '015002': [250, 26],
  '015003': [280, 26],
  '015004': [310, 26],
  '016001': [220, 26],
  '016002': [250, 26],
  '016003': [280, 26],
  '016004': [310, 26],
  '017001': [220, 26],
  '017002': [250, 26],
  '017003': [280, 26],
  '017004': [310, 26],
  '018001': [220, 26],
  '018002': [250, 26],
  '018003': [280, 26],
  '018004': [310, 26],
  '019000': [5, 45],
  '020000': [30, 45],
  '021001': [45, 10],
  '021002': [75, 10],
  '021003': [105, 10],
  '022000': [100, 45],
  '023000': [5, 45],
  '024000': [150, 45],
  '025000': [100, 45],
  '026000': [30, 45],
  '027000': [5, 45],
  '028000': [100, 45],
  '029000': [5, 45],
  '030000': [5, 45],
  '031000': [125, 45],
  '032000': [100, 45],
  '033000': [30, 45],
  '034000': [30, 45],
  '035000': [100, 45],
  '036000': [30, 45],
  '037000': [100, 45],
  '038000': [100, 45],
  '039000': [5, 45],
  '040000': [150, 45],
  '041000': [100, 45],
  '042000': [5, 45],
  '043000': [100, 45],
  '044000': [5, 45],
  '045000': [344, 26],
  '046000': [5, 45],
  '047000': [164, 26],
  '048000': [100, 45],
  '049000': [194, 26],
  '050000': [5, 45],
  '051000': [100, 45],
  '052000': [314, 68],
  '053000': [100, 45],
  '055000': [320, 68],
  '056000': [183, 68],
  '057000': [289, 68],
  '058000': [30, 45],
  '059000': [294, 68],
  '060000': [125, 45],
  '061001': [220, 26],
  '061002': [250, 26],
  '061003': [280, 26],
  '061004': [310, 26],
  '062000': [104, 26],
  '063000': [181, 68],
  '064000': [374, 68],
  '065000': [286, 68],
  '066000': [182, 68],
  '067000': [211, 68],
  '068000': [183, 68],
  '069000': [240, 68],
  '070000': [183, 68],
  '071000': [150, 45],
  '072000': [104, 26],
  '073000': [104, 26],
  '074000': [55, 45],
  '075000': [125, 45],
  '076000': [104, 68],
  '077000': [30, 45],
  '078000': [240, 68],
  '079000': [344, 68],
  '080000': [55, 45],
  '081000': [104, 26],
  '082000': [354, 68],
  '083000': [55, 45],
  '084000': [125, 45],
  '085000': [349, 68],
  '086000': [183, 68],
  '087000': [125, 45],
  '088000': [150, 40],
  '089000': [211, 68],
  '090000': [241, 68],
  '091000': [150, 45],
  '092000': [104, 26],
  '093000': [490, 68],
  '094000': [324, 68],
  '095000': [284, 68],
  '096000': [164, 68],
  '097000': [150, 60],
  '098000': [104, 68],
  '099000': [194, 68],
  '100000': [150, 45],
  '101000': [243, 68],
  '102000': [357, 68],
  '103000': [104, 68],
  '104000': [150, 45],
  '105000': [295, 68],
  '106000': [327, 68],
  '107000': [125, 45],
  '108000': [125, 45],
  '109000': [135, 26],
  '110000': [211, 68],
  '111000': [224, 68],
  '112000': [104, 26],
  '113000': [211, 68],
  '114000': [315, 68],
  '115000': [347, 68],
  '116000': [150, 45],
  '117000': [104, 68],
  '118000': [150, 45],
  '119000': [430, 68],
  '120000': [30, 45],
  '121000': [104, 26],
  '122000': [55, 45],
  '123000': [30, 45],
  '124001': [430, 26],
  '124002': [460, 26],
  '124003': [490, 26],
  '125000': [320, 68],
  '126000': [349, 68],
  '128000': [289, 68],
  '129000': [125, 45],
  '130000': [30, 45],
  '131000': [125, 45],
  '132000': [55, 45],
  '133000': [125, 45],
  '134000': [150, 35],
  '135000': [150, 55],
  '136000': [460, 68],
  '137000': [104, 68],
  '138000': [352, 68],
  '139000': [150, 20],
  '140000': [125, 45],
  '141000': [55, 45],
  '142000': [242, 68],
  '143000': [321, 68],
  '144000': [290, 68],
  '145000': [214, 68],
  '146000': [254, 68],
  '147000': [55, 45],
  '148000': [30, 45],
  '149000': [244, 68],
  '150000': [104, 68],
  '151001': [220, 26],
  '151002': [250, 26],
  '151003': [280, 26],
  '151004': [310, 26],
  '152000': [212, 68],
  '153000': [242, 68],
  '154000': [183, 68],
  '155000': [55, 45],
  '156000': [125, 45],
  '157000': [293, 68],
  '158000': [324, 68],
  '159000': [150, 45],
  '160000': [5, 45],
  '161000': [5, 45],
  '162000': [314, 89],
  '163000': [30, 45],
  '164000': [104, 26],
  '165000': [150, 45],
  '166000': [352, 68],
  '167000': [104, 68],
  '168000': [55, 45],
  '169000': [55, 45],
  '170000': [211, 68],
  '171000': [55, 45],
  '172001': [220, 26],
  '172002': [250, 26],
  '172003': [280, 26],
  '172004': [310, 26],
  '173000': [286, 89],
  '174000': [183, 68],
  '175000': [30, 45],
  '176000': [104, 68],
  '177000': [150, 45],
  '178000': [211, 68],
  '179000': [341, 89],
  '180000': [55, 45],
  '181000': [320, 68],
  '182000': [289, 68],
  '183000': [0, 0],
  '184000': [240, 68],
  '185001': [45, 10],
  '185002': [75, 10],
  '185003': [105, 10],
  '186000': [349, 68],
  '187001': [441, 26],
  '187002': [472, 26],
  '187003': [503, 26],
  '188000': [411, 68],
  '189000': [465, 68],
  '190000': [438, 68],
  '191000': [30, 45],
  '192000': [55, 45],
  '193000': [55, 45],
  '194000': [125, 45],
  '195000': [100, 45],
  '196000': [5, 45],
  '197000': [254, 26],
  '198001': [45, 10],
  '198002': [75, 10],
  '198003': [105, 10],
  '199001': [45, 10],
  '199002': [75, 10],
  '199003': [105, 10],
  '200000': [100, 45],
  '201000': [125, 45],
  '202000': [150, 45],
  '203000': [150, 0],
  '204000': [150, 45],
  '205000': [284, 26],
  '206000': [55, 45],
  '207000': [5, 45],
  '210000': [5, 45],
  '216000': [30, 45],
  '217000': [30, 45],
  '218000': [374, 26],
  '220000': [314, 26],
}

def window_branch_path(branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, f"{branch}.(WindowSimple).xdb")
def window_branchshared_path(branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, f"{branch}.(WindowSimpleShared).xdb")
def button_base_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, f"{id}.(WindowMSButton).xdb")
def button_shared_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, f"{id}.(WindowMSButtonShared).xdb")
def button_bgwindow_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, f"{id}_icon.(WindowSimple).xdb")
def button_bgshared_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, f"{id}_icon.(WindowSimpleShared).xdb")
def button_background_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, f"{id}.(BackgroundSimpleScallingTexture).xdb")
def button_selected_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, "highlight", f"{id}_highlight.(WindowMSButton).xdb")
def ui_message_up_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, "highlight", f"{id}_on.(UISSendUIMessage).xdb")
def ui_message_down_path(id, branch):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, "highlight", f"{id}_off.(UISSendUIMessage).xdb")
def desc_ui_message_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}.(UISSendUIMessage).xdb")
def desc_window_base_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_window.(WindowSimple).xdb")
def desc_window_shared_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_window.(WindowSimpleShared).xdb")
def desc_icon_base_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_icon.(WindowMSButton).xdb")
def desc_icon_shared_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_icon.(WindowMSButtonShared).xdb")
def desc_icon_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_icon.(BackgroundSimpleScallingTexture).xdb")
def skill_name_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_name.(WindowTextView).xdb")
def skill_desc_path(id):
    return os.path.join(skills_pedia_path, "_Description", id, f"{id}_desc.(WindowTextView).xdb")

def write_from_template(tpl_name, output_path, variables):
    tpl = jinja_env.get_template(tpl_name)
    rendered = tpl.render(variables)
    with open(output_path, 'w') as out_file:
        out_file.write(rendered)

def get_skill_id_from_name(name):
    nb = -1
    for skill in skills_data["Table_HeroSkill_SkillID"]["objects"]["Item"]:
        nb = nb + 1
        if skill["ID"] == name:
            return nb
    print(f"WARN: prerequisite skill with name {name} not found")
    return 0

def find_prerequisites(base_skill, req_id):
    skill = skills_data["Table_HeroSkill_SkillID"]["objects"]["Item"][req_id]
    if skill["obj"]["SkillType"] == "SKILLTYPE_STANDART_PERK":
        return [f"{base_skill:03}001"]
    if skill["obj"]["SkillType"] == "SKILLTYPE_SPECIAL_PERK":
        req_req = get_skill_id_from_name(skill["obj"]["SkillPrerequisites"]["Item"][0]["dependenciesIDs"]["Item"])
        req = [f"{req_req:03}000"]
        req.append(f"{base_skill:03}001")
        req.append(f"{base_skill:03}002")
        return req
    
def find_icon_size(path:str):
    if path.startswith("/UI/H5A"):
        if "128x128" in path:
            return 128
        elif "/Blood_Rage/" in path:
            if ("Perk_MightOverMagic" in path) or ("Perk_Memory_of_Our_Blood" in path):
                return 64
            else:
                return 128
        elif ("/Voice/" in path):
            if ("Perk_Voice_Training" in path) or ("Perk_Mighty_Voice" in path) or ("Perk_Voice_of_Rage" in path):
                return 128
            else:
                return 64
        elif ("Shatter_Light_Magic" in path) or ("Bodybuilding" in path) or ("Corrupt_Light" in path) or ("Path_of_War" in path):
            return 64
        else:
            return 128
    return 64


branches = ["Innates",
            "Courage", "Avenger", "Runelore", "Artificier", "Arcanism", "Necromancy", "Gating", "BloodRage",
            "Offence", "Defense", "Learning", "Sorcery", "LightMagic", "DarkMagic", "DestructiveMagic", "NaturalMagic",
            "Combat", "Leadership", "Logistics", "Warfare", "ShatterMagic", "Governance", "Training", "Voice", "Spiritism"]

counter = -1
for skill in skills_data["Table_HeroSkill_SkillID"]["objects"]["Item"]:
    counter = counter + 1
    elements = {}
    prerequisites = {}
    if skill["obj"]["SkillType"] == "SKILLTYPE_SKILL":
        if not skill["obj"]["NameFileRef"]:
            continue
        ranks = len(skill["obj"]["NameFileRef"]["Item"])
        for k in range(1,ranks+1):
            id = f"{counter:03}{k:03}"
            elements[id] = {
                'icon': skill["obj"]["Texture"]["Item"][k]["@href"],
                'name': skill["obj"]["NameFileRef"]["Item"][k-1]["@href"],
                'desc': skill["obj"]["DescriptionFileRef"]["Item"][k-1]["@href"],
            }
            prerequisites[id] = []
            if k > 1:
                prerequisites[id].append(f"{counter:03}{(k-1):03}")
            if k > 2:
                prerequisites[id].append(f"{counter:03}{(k-2):03}")
            if k > 3:
                prerequisites[id].append(f"{counter:03}{(k-3):03}")
    else:
        id = f"{counter:03}000"
        elements[id] = {
            'icon': skill["obj"]["Texture"]["Item"][1]["@href"],
            'name': skill["obj"]["NameFileRef"]["Item"]["@href"],
            'desc': skill["obj"]["DescriptionFileRef"]["Item"]["@href"],
        }
        base_skill = get_skill_id_from_name(skill["obj"]["BasicSkillID"])
        if base_skill == 0 or base_skill == 54:
            prerequisites[id] = []
        else:
            if skill["obj"]["SkillType"] == "SKILLTYPE_STANDART_PERK":
                prerequisites[id] = [f"{base_skill:03}001"]
            if skill["obj"]["SkillType"] == "SKILLTYPE_SPECIAL_PERK":
                if skill["obj"]["SkillPrerequisites"]:
                    req_perk = get_skill_id_from_name(skill["obj"]["SkillPrerequisites"]["Item"][0]["dependenciesIDs"]["Item"])
                    prerequisites[id] = find_prerequisites(base_skill, req_perk)
                    perk_tier = (len(prerequisites[id]) + 3) // 2
                    prerequisites[id].append(f"{req_perk:03}000")
                    prerequisites[id].append(f"{base_skill:03}{perk_tier:03}")
                else:
                    prerequisites[id] = [f"{base_skill:03}001"]
    # print(prerequisites)
    for id in elements:
        found = False
        for branch in branches:
            if os.path.isfile(button_base_path(id, branch)):
                print(f"Processing ID {id}...")
                if found:
                    print(f"WARN: found duplicate button file for ID {id}")
                    continue
                else:
                    found = True
                x = coordinates_skills[id][0]
                y = coordinates_skills[id][1]
                icon_size = find_icon_size(elements[id]['icon'])
                directories = {
                    os.path.join(skills_pedia_path, "_Skills", branch, id, "highlight"),
                    os.path.join(skills_pedia_path, "_Description", id),
                }
                for targetDir in directories:
                    if not os.path.exists(targetDir):
                        os.makedirs(targetDir)
                # dirrm = os.path.join(skills_pedia_path, branch, id, "selection")
                # if os.path.exists(dirrm):
                #     for file in os.listdir(dirrm):
                #         os.remove(os.path.join(dirrm, file))
                #     os.rmdir(dirrm)
                write_from_template("button.(WindowMSButton).xdb.j2", button_base_path(id, branch), {'skill_id': id, 'skill_name': skill['ID'], 'pos_x': x, 'pos_y': y})
                write_from_template("buttonshared.(WindowMSButtonShared).xdb.j2", button_shared_path(id, branch), {'branch': branch, 'skill_id': id, 'required_skills': prerequisites[id]})
                write_from_template("skillicon.(WindowSimple).xdb.j2", button_bgwindow_path(id, branch), {'skill_id': id})
                write_from_template("skillicon.(WindowSimpleShared).xdb.j2", button_bgshared_path(id, branch), {'skill_id': id})
                write_from_template("icon.(BackgroundSimpleScallingTexture).xdb.j2", button_background_path(id, branch), {'icon_path': elements[id]['icon'], 'icon_size': icon_size})
                write_from_template("selection.(WindowMSButton).xdb.j2", button_selected_path(id, branch), {'skill_id': id, 'pos_x': x, 'pos_y': y})
                write_from_template("uimessage1.(UISSendUIMessage).xdb.j2", ui_message_up_path(id, branch), {'skill_id': id})
                write_from_template("uimessage2.(UISSendUIMessage).xdb.j2", ui_message_down_path(id, branch), {'skill_id': id})
                write_from_template("descuimessage.(UISSendUIMessage).xdb.j2", desc_ui_message_path(id), {'skill_id': id})
                write_from_template("windowbase.(WindowSimple).xdb.j2", desc_window_base_path(id), {'skill_id': id})
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", desc_window_shared_path(id), {'skill_id': id})
                write_from_template("iconbase.(WindowMSButton).xdb.j2", desc_icon_base_path(id), {'skill_id': id})
                write_from_template("iconshared.(WindowMSButtonShared).xdb.j2", desc_icon_shared_path(id), {'skill_id': id})
                write_from_template("icon.(BackgroundSimpleScallingTexture).xdb.j2", desc_icon_path(id), {'icon_path': elements[id]['icon'], 'icon_size': icon_size})
                write_from_template("skillname.(WindowTextView).xdb.j2", skill_name_path(id), {'skill_id': id, 'name_path': elements[id]['name']})
                write_from_template("skilldesc.(WindowTextView).xdb.j2", skill_desc_path(id), {'skill_id': id, 'desc_path': elements[id]['desc']})
                all_buttons.write(f"<Item href=\"{id}/{id}.(WindowMSButton).xdb#xpointer(/WindowMSButton)\"/>\n")
                all_selected.write(f"<Item href=\"{id}/{id}_select.(WindowMSButton).xdb#xpointer(/WindowMSButton)\"/>\n")
                all_windows.write(f"<Item href=\"{id}/{id}_window.(WindowSimple).xdb#xpointer(/WindowSimple)\"/>\n")
        if not found:
            skill_name = skill['ID']
            if elements[id]['name'] != "":
                with open(os.path.join(root_text_path, elements[id]['name'][1:]), 'r', encoding="utf-16") as skill_name_txt:
                    skill_name = skill_name_txt.read().strip()
            print(f"WARN: missing button file for ID {id} ({skill_name})")

all_buttons.close()
all_selected.close()
all_windows.close()
