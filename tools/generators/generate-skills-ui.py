
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

coordinates_branch = {
    "HERO_SKILL_LOGISTICS": [0, 140], "HERO_SKILL_SHATTER_MAGIC": [190, 140], "HERO_SKILL_COMBAT": [380, 140],
    "HERO_SKILL_WARFARE": [0, 220], "HERO_SKILL_LIGHT_MAGIC": [190, 220], "HERO_SKILL_OFFENCE": [380, 220],
    "HERO_SKILL_GOVERNANCE": [0, 300], "HERO_SKILL_DARK_MAGIC": [190, 220], "HERO_SKILL_DEFENSE": [380, 220],
    "HERO_SKILL_LEADERSHIP": [0, 380], "HERO_SKILL_NATURAL_MAGIC": [190, 380], "HERO_SKILL_LEARNING": [380, 380],
    "HERO_SKILL_TRAINING": [0, 460], "HERO_SKILL_DESTRUCTIVE_MAGIC": [190, 460], "HERO_SKILL_SORCERY": [380, 460],
    "HERO_SKILL_VOICE": [380, 460],
}

logistics_x = coordinates_branch["HERO_SKILL_LOGISTICS"][0]
logistics_y = coordinates_branch["HERO_SKILL_LOGISTICS"][1]
shatter_x = coordinates_branch["HERO_SKILL_SHATTER_MAGIC"][0]
shatter_y = coordinates_branch["HERO_SKILL_SHATTER_MAGIC"][1]
combat_x = coordinates_branch["HERO_SKILL_COMBAT"][0]
combat_y = coordinates_branch["HERO_SKILL_COMBAT"][1]
warfare_x = coordinates_branch["HERO_SKILL_WARFARE"][0]
warfare_y = coordinates_branch["HERO_SKILL_WARFARE"][1]
light_x = coordinates_branch["HERO_SKILL_LIGHT_MAGIC"][0]
light_y = coordinates_branch["HERO_SKILL_LIGHT_MAGIC"][1]
offence_x = coordinates_branch["HERO_SKILL_OFFENCE"][0]
offence_y = coordinates_branch["HERO_SKILL_OFFENCE"][1]
governance_x = coordinates_branch["HERO_SKILL_GOVERNANCE"][0]
governance_y = coordinates_branch["HERO_SKILL_GOVERNANCE"][1]
dark_x = coordinates_branch["HERO_SKILL_DARK_MAGIC"][0]
dark_y = coordinates_branch["HERO_SKILL_DARK_MAGIC"][1]
defense_x = coordinates_branch["HERO_SKILL_DEFENSE"][0]
defense_y = coordinates_branch["HERO_SKILL_DEFENSE"][1]
leadership_x = coordinates_branch["HERO_SKILL_LEADERSHIP"][0]
leadership_y = coordinates_branch["HERO_SKILL_LEADERSHIP"][1]
natural_x = coordinates_branch["HERO_SKILL_NATURAL_MAGIC"][0]
natural_y = coordinates_branch["HERO_SKILL_NATURAL_MAGIC"][1]
learning_x = coordinates_branch["HERO_SKILL_LEARNING"][0]
learning_y = coordinates_branch["HERO_SKILL_LEARNING"][1]
training_x = coordinates_branch["HERO_SKILL_TRAINING"][0]
training_y = coordinates_branch["HERO_SKILL_TRAINING"][1]
destructive_x = coordinates_branch["HERO_SKILL_DESTRUCTIVE_MAGIC"][0]
destructive_y = coordinates_branch["HERO_SKILL_DESTRUCTIVE_MAGIC"][1]
sorcery_x = coordinates_branch["HERO_SKILL_SORCERY"][0]
sorcery_y = coordinates_branch["HERO_SKILL_SORCERY"][1]
voice_x = coordinates_branch["HERO_SKILL_VOICE"][0]
voice_y = coordinates_branch["HERO_SKILL_VOICE"][1]

coordinates_skills = {
  '001001': [logistics_x+45, logistics_y+10],
  '001002': [logistics_x+75, logistics_y+10],
  '001003': [logistics_x+105, logistics_y+10],
  '002001': [warfare_x+45, warfare_y+10],
  '002002': [warfare_x+75, warfare_y+10],
  '002003': [warfare_x+105, warfare_y+10],
  '003001': [learning_x+45, learning_y+10],
  '003002': [learning_x+75, learning_y+10],
  '003003': [learning_x+105, learning_y+10],
  '004000': [leadership_x+100, leadership_y+45],
  '005000': [offence_x+125, offence_y+45],
  '006001': [offence_x+45, offence_y+10],
  '006002': [offence_x+75, offence_y+10],
  '006003': [offence_x+105, offence_y+10],
  '007001': [defense_x+45, defense_y+10],
  '007002': [defense_x+75, defense_y+10],
  '007003': [defense_x+105, defense_y+10],
  '008001': [sorcery_x+45, sorcery_y+10],
  '008002': [sorcery_x+75, sorcery_y+10],
  '008003': [sorcery_x+105, sorcery_y+10],
  '009001': [destructive_x+45, destructive_y+10],
  '009002': [destructive_x+75, destructive_y+10],
  '009003': [destructive_x+105, destructive_y+10],
  '010001': [dark_x+45, dark_y+10],
  '010002': [dark_x+75, dark_y+10],
  '010003': [dark_x+105, dark_y+10],
  '011001': [light_x+45, light_y+10],
  '011002': [light_x+75, light_y+10],
  '011003': [light_x+105, light_y+10],
  '012001': [natural_x+45, natural_y+10],
  '012002': [natural_x+75, natural_y+10],
  '012003': [natural_x+105, natural_y+10],
  '013001': [combat_x+45, combat_y+10],
  '013002': [combat_x+75, combat_y+10],
  '013003': [combat_x+105, combat_y+10],
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
  '019000': [logistics_x+5, logistics_y+45],
  '020000': [logistics_x+30, logistics_y+45],
  '021001': [governance_x+45, governance_y+10],
  '021002': [governance_x+75, governance_y+10],
  '021003': [governance_x+105, governance_y+10],
  '022000': [warfare_x+100, warfare_y+45],
  '023000': [warfare_x+5, warfare_y+45],
  '024000': [warfare_x+150, warfare_y+45],
  '025000': [learning_x+100, learning_y+45],
  '026000': [learning_x+30, learning_y+45],
  '027000': [learning_x+5, learning_y+45],
  '028000': [logistics_x+100, logistics_y+45],
  '029000': [governance_x+5, governance_y+45],
  '030000': [leadership_x+5, leadership_y+45],
  '031000': [training_x+5, training_y+45],
  '032000': [training_x+100, training_y+45],
  '033000': [governance_x+30, governance_y+45],
  '034000': [offence_x+30, offence_y+45],
  '035000': [offence_x+100, offence_y+45],
  '036000': [training_x+30, training_y+45],
  '037000': [shatter_x+100, shatter_y+45],
  '038000': [defense_x+100, defense_y+45],
  '039000': [training_x+5, training_y+45],
  '040000': [sorcery_x+150, sorcery_y+45],
  '041000': [sorcery_x+100, sorcery_y+45],
  '042000': [sorcery_x+5, sorcery_y+45],
  '043000': [destructive_x+100, destructive_y+45],
  '044000': [destructive_x+5, destructive_y+45],
  '045000': [344, 26],
  '046000': [dark_x+5, dark_y+45],
  '047000': [164, 26],
  '048000': [dark_x+100, dark_y+45],
  '049000': [194, 26],
  '050000': [light_x+5, light_y+45],
  '051000': [light_x+100, light_y+45],
  '052000': [314, 68],
  '053000': [natural_x+100, natural_y+45],
  '055000': [320, 68],
  '056000': [183, 68],
  '057000': [289, 68],
  '058000': [dark_x+30, dark_y+45],
  '059000': [294, 68],
  '060000': [combat_x+125, combat_y+45],
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
  '071000': [learning_x+150, learning_y+45],
  '072000': [104, 26],
  '073000': [104, 26],
  '074000': [warfare_x+55, warfare_y+45],
  '075000': [leadership_x+125, leadership_y+45],
  '076000': [104, 68],
  '077000': [defense_x+30, defense_y+45],
  '078000': [240, 68],
  '079000': [344, 68],
  '080000': [governance_x+55, governance_y+45],
  '081000': [104, 26],
  '082000': [354, 68],
  '083000': [dark_x+55, dark_y+45],
  '084000': [natural_x+125, natural_y+45],
  '085000': [349, 68],
  '086000': [183, 68],
  '087000': [learning_x+125, learning_y+45],
  '088000': [natural_x+150, natural_y+40],
  '089000': [211, 68],
  '090000': [241, 68],
  '091000': [combat_x+150, combat_y+45],
  '092000': [104, 26],
  '094000': [324, 68],
  '095000': [284, 68],
  '096000': [164, 68],
  '097000': [natural_x+150, natural_y+60],
  '098000': [104, 68],
  '099000': [194, 68],
  '100000': [dark_x+150, dark_y+45],
  '101000': [243, 68],
  '102000': [357, 68],
  '103000': [104, 68],
  '104000': [destructive_x+150, destructive_y+45],
  '105000': [295, 68],
  '106000': [327, 68],
  '107000': [destructive_x+125, destructive_y+45],
  '108000': [dark_x+125, dark_y+45],
  '109000': [245, 68],
  '110000': [211, 68],
  '111000': [224, 68],
  '112000': [104, 26],
  '113000': [211, 68],
  '114000': [315, 68],
  '115000': [347, 68],
  '116000': [offence_x+150, offence_y+45],
  '117000': [104, 68],
  '118000': [leadership_x+150, leadership_y+45],
  '119000': [220, 68],
  '120000': [shatter_x+30, shatter_y+45],
  '121000': [104, 26],
  '122000': [natural_x+55, natural_y+45],
  '123000': [natural_x+30, natural_y+45],
  '124001': [235, 26],
  '124002': [265, 26],
  '124003': [295, 26],
  '125000': [320, 68],
  '126000': [349, 68],
  '128000': [289, 68],
  '129000': [logistics_x+125, logistics_y+45],
  '130000': [warfare_x+30, warfare_y+45],
  '131000': [defense_x+125, defense_y+45],
  '132000': [light_x+55, light_y+45],
  '133000': [shatter_x+125, shatter_y+45],
  '134000': [shatter_x+150, shatter_y+35],
  '135000': [shatter_x+150, shatter_y+55],
  '136000': [104, 26],
  '137000': [104, 68],
  '138000': [352, 68],
  '139000': [natural_x+150, natural_y+20],
  '140000': [sorcery_x+125, sorcery_y+45],
  '141000': [offence_x+55, offence_y+45],
  '142000': [242, 68],
  '143000': [321, 68],
  '144000': [290, 68],
  '145000': [214, 68],
  '146000': [254, 68],
  '147000': [destructive_x+55, destructive_y+45],
  '148000': [sorcery_x+30, sorcery_y+45],
  '149000': [244, 68],
  '150000': [104, 68],
  '151001': [220, 26],
  '151002': [250, 26],
  '151003': [280, 26],
  '151004': [310, 26],
  '152000': [212, 68],
  '153000': [242, 68],
  '154000': [183, 68],
  '155000': [sorcery_x+55, sorcery_y+45],
  '156000': [warfare_x+125, warfare_y+45],
  '157000': [293, 68],
  '158000': [324, 68],
  '159000': [training_x+150, training_y+45],
  '160000': [offence_x+5, offence_y+45],
  '161000': [defense_x+5, defense_y+45],
  '162000': [voice_x+314, voice_y+89],
  '163000': [destructive_x+30, destructive_y+45],
  '164000': [104, 26],
  '165000': [light_x+150, light_y+45],
  '166000': [352, 68],
  '167000': [104, 68],
  '168000': [logistics_x+55, logistics_y+45],
  '169000': [learning_x+55, learning_y+45],
  '170000': [211, 68],
  '171000': [defense_x+55, defense_y+45],
  '172001': [220, 26],
  '172002': [250, 26],
  '172003': [280, 26],
  '172004': [310, 26],
  '173000': [voice_x+286, voice_y+45],
  '174000': [183, 68],
  '175000': [combat_x+30, combat_y+45],
  '176000': [104, 68],
  '177000': [logistics_x+150, logistics_y+45],
  '178000': [211, 68],
  '179000': [voice_x+341, voice_y+45],
  '180000': [combat_x+55, combat_y+45],
  '181000': [320, 68],
  '182000': [289, 68],
  '183000': [285, 68],
  '184000': [240, 68],
  '185001': [training_x+45, training_y+10],
  '185002': [training_x+75, training_y+10],
  '185003': [training_x+105, training_y+10],
  '186000': [349, 68],
  '187001': [voice_x+441, voice_y+26],
  '187002': [voice_x+472, voice_y+26],
  '187003': [voice_x+503, voice_y+26],
  '188000': [voice_x+411, voice_y+45],
  '189000': [voice_x+465, voice_y+45],
  '190000': [voice_x+438, voice_y+45],
  '191000': [leadership_x+30, leadership_y+45],
  '192000': [leadership_x+55, leadership_y+45],
  '193000': [training_x+55, training_y+45],
  '194000': [light_x+125, light_y+45],
  '195000': [combat_x+100, combat_y+45],
  '196000': [combat_x+5, combat_y+45],
  '197000': [0, 0],
  '198001': [leadership_x+45, leadership_y+10],
  '198002': [leadership_x+75, leadership_y+10],
  '198003': [leadership_x+105, leadership_y+10],
  '199001': [shatter_x+45, shatter_y+10],
  '199002': [shatter_x+75, shatter_y+10],
  '199003': [shatter_x+105, shatter_y+10],
  '200000': [governance_x+100, governance_y+45],
  '201000': [governance_x+125, governance_y+45],
  '202000': [governance_x+150, governance_y+45],
  '203000': [natural_x+150, natural_y+0],
  '204000': [defense_x+150, defense_y+45],
  '205000': [284, 26],
  '206000': [shatter_x+55, shatter_y+45],
  '207000': [shatter_x+5, shatter_y+45],
  '210000': [natural_x+5, natural_y+45],
  '215000': [374, 26],
  '216000': [light_x+30, light_y+45],
  '217000': [310, 68],
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
