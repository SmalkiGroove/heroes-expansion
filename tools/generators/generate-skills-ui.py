
import os
import xmltodict
from jinja2 import Environment, FileSystemLoader

root_text_path = "../../game_texts/texts-EN"
skills_xdb_path = "../../game_data/skills/GameMechanics/RefTables/Skills.xdb"
skills_pedia_path = "../../game_data/www-skills/UI/Doc/Skills"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates-skills"))

with open(skills_xdb_path, 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())

all_buttons = open("outputs/skills_skillbuttons.xml", 'w')
all_selected = open("outputs/skills_selectionhighlights.xml", 'w')
all_windows = open("outputs/skills_descriptionviews.xml", 'w')

branches = ["Innates",
            "Courage", "Avenger", "Runelore", "Artificier", "Arcanism", "Necromancy", "Gating", "BloodRage", "Spiritism",
            "Offence", "Defense", "Learning", "Sorcery", "LightMagic", "DarkMagic", "DestructiveMagic", "NaturalMagic",
            "Combat", "Leadership", "Logistics", "Warfare", "ShatterMagic", "Governance", "Training", "Despotism", "Voice"]

coordinates_branch = {
    "Logistics": [0, 0], "ShatterMagic": [190, 0], "Combat": [380, 0],
    "Warfare": [0, 80], "LightMagic": [190, 80], "Offence": [380, 80],
    "Governance": [0, 160], "DarkMagic": [190, 160], "Defense": [380, 160],
    "Leadership": [0, 240], "NaturalMagic": [190, 240], "Learning": [380, 240],
    "Training": [0, 320], "DestructiveMagic": [190, 320], "Sorcery": [380, 320],
    "Voice": [380, 320], "Despotism": [0, 320],
    "Innates": [104, 0], "Racial": [180, 0],
}
coordinates_relative = {
    "Logistics": [0, 0], "ShatterMagic": [0, 0], "Combat": [0, 0],
    "Warfare": [0, 0], "LightMagic": [0, 0], "Offence": [0, 0],
    "Governance": [0, 0], "DarkMagic": [0, 0], "Defense": [0, 0],
    "Leadership": [0, 0], "NaturalMagic": [0, 0], "Learning": [0, 0],
    "Training": [0, 0], "DestructiveMagic": [0, 0], "Sorcery": [0, 0],
    "Voice": [0, 0], "Despotism": [0, 0], 
    "Innates": [104, 0], "Racial": [180, 0],
}

logistics_x = coordinates_relative["Logistics"][0]
logistics_y = coordinates_relative["Logistics"][1]
shatter_x = coordinates_relative["ShatterMagic"][0]
shatter_y = coordinates_relative["ShatterMagic"][1]
combat_x = coordinates_relative["Combat"][0]
combat_y = coordinates_relative["Combat"][1]
warfare_x = coordinates_relative["Warfare"][0]
warfare_y = coordinates_relative["Warfare"][1]
light_x = coordinates_relative["LightMagic"][0]
light_y = coordinates_relative["LightMagic"][1]
offence_x = coordinates_relative["Offence"][0]
offence_y = coordinates_relative["Offence"][1]
governance_x = coordinates_relative["Governance"][0]
governance_y = coordinates_relative["Governance"][1]
dark_x = coordinates_relative["DarkMagic"][0]
dark_y = coordinates_relative["DarkMagic"][1]
defense_x = coordinates_relative["Defense"][0]
defense_y = coordinates_relative["Defense"][1]
leadership_x = coordinates_relative["Leadership"][0]
leadership_y = coordinates_relative["Leadership"][1]
natural_x = coordinates_relative["NaturalMagic"][0]
natural_y = coordinates_relative["NaturalMagic"][1]
learning_x = coordinates_relative["Learning"][0]
learning_y = coordinates_relative["Learning"][1]
training_x = coordinates_relative["Training"][0]
training_y = coordinates_relative["Training"][1]
destructive_x = coordinates_relative["DestructiveMagic"][0]
destructive_y = coordinates_relative["DestructiveMagic"][1]
sorcery_x = coordinates_relative["Sorcery"][0]
sorcery_y = coordinates_relative["Sorcery"][1]
despotism_x = coordinates_relative["Despotism"][0]
despotism_y = coordinates_relative["Despotism"][1]
voice_x = coordinates_relative["Voice"][0]
voice_y = coordinates_relative["Voice"][1]
innates_x = coordinates_relative["Innates"][0]
innates_y = coordinates_relative["Innates"][1]
racial_x = coordinates_relative["Racial"][0]
racial_y = coordinates_relative["Racial"][1]

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
  '004001': [racial_x+40, racial_y+26],
  '004002': [racial_x+70, racial_y+26],
  '004003': [racial_x+100, racial_y+26],
  '004004': [racial_x+130, racial_y+26],
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
  '014001': [racial_x+40, racial_y+26],
  '014002': [racial_x+70, racial_y+26],
  '014003': [racial_x+100, racial_y+26],
  '014004': [racial_x+130, racial_y+26],
  '015001': [racial_x+40, racial_y+26],
  '015002': [racial_x+70, racial_y+26],
  '015003': [racial_x+100, racial_y+26],
  '015004': [racial_x+130, racial_y+26],
  '016001': [racial_x+40, racial_y+26],
  '016002': [racial_x+70, racial_y+26],
  '016003': [racial_x+100, racial_y+26],
  '016004': [racial_x+130, racial_y+26],
  '017001': [racial_x+40, racial_y+26],
  '017002': [racial_x+70, racial_y+26],
  '017003': [racial_x+100, racial_y+26],
  '017004': [racial_x+130, racial_y+26],
  '018001': [racial_x+40, racial_y+26],
  '018002': [racial_x+70, racial_y+26],
  '018003': [racial_x+100, racial_y+26],
  '018004': [racial_x+130, racial_y+26],
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
  '031000': [shatter_x+125, shatter_y+55],
  '032000': [training_x+125, training_y+45],
  '033000': [governance_x+30, governance_y+45],
  '034000': [offence_x+30, offence_y+45],
  '035000': [offence_x+100, offence_y+45],
  '036000': [training_x+30, training_y+45],
  '037000': [shatter_x+5, shatter_y+45],
  '038000': [defense_x+100, defense_y+45],
  '039000': [training_x+5, training_y+45],
  '040000': [sorcery_x+150, sorcery_y+45],
  '041000': [sorcery_x+100, sorcery_y+45],
  '042000': [sorcery_x+5, sorcery_y+45],
  '043000': [destructive_x+100, destructive_y+45],
  '044000': [destructive_x+5, destructive_y+45],
  '045000': [innates_x+240, innates_y+26],
  '046000': [dark_x+5, dark_y+45],
  '047000': [innates_x+60, innates_y+26],
  '048000': [dark_x+100, dark_y+45],
  '049000': [innates_x+90, innates_y+26],
  '050000': [light_x+5, light_y+45],
  '051000': [light_x+100, light_y+45],
  '052000': [innates_x+210, innates_y+68],
  '053000': [natural_x+100, natural_y+45],
  '055000': [320, 68],
  '056000': [183, 68],
  '057000': [289, 68],
  '058000': [dark_x+30, dark_y+45],
  '059000': [294, 68],
  '060000': [combat_x+125, combat_y+45],
  '061000': [leadership_x+100, leadership_y+45],
  '062000': [innates_x+0, innates_y+26],
  '063000': [181, 68],
  '064000': [innates_x+150, innates_y+26],
  '065000': [286, 68],
  '066000': [182, 68],
  '067000': [211, 68],
  '068000': [183, 68],
  '069000': [240, 68],
  '070000': [183, 68],
  '071000': [learning_x+150, learning_y+45],
  '072000': [innates_x+0, innates_y+26],
  '073000': [innates_x+0, innates_y+26],
  '074000': [warfare_x+55, warfare_y+45],
  '075000': [leadership_x+125, leadership_y+45],
  '076000': [innates_x+0, innates_y+68],
  '077000': [defense_x+30, defense_y+45],
  '078000': [240, 68],
  '079000': [innates_x+240, innates_y+68],
  '080000': [governance_x+55, governance_y+45],
  '081000': [innates_x+0, innates_y+26],
  '082000': [354, 68],
  '083000': [dark_x+55, dark_y+45],
  '084000': [natural_x+125, natural_y+45],
  '085000': [349, 68],
  '086000': [183, 68],
  '087000': [learning_x+125, learning_y+45],
  '088000': [natural_x+150, natural_y+40],
  '089000': [211, 68],
  '090000': [241, 68],
  '091000': [combat_x+150, combat_y+55],
  '092000': [innates_x+0, innates_y+26],
  '094000': [324, 68],
  '095000': [innates_x+180, innates_y+68],
  '096000': [innates_x+270, innates_y+26],
  '097000': [natural_x+150, natural_y+60],
  '098000': [innates_x+0, innates_y+68],
  '099000': [innates_x+90, innates_y+68],
  '100000': [dark_x+150, dark_y+45],
  '101000': [243, 68],
  '102000': [357, 68],
  '103000': [innates_x+0, innates_y+68],
  '104000': [destructive_x+150, destructive_y+45],
  '105000': [295, 68],
  '106000': [327, 68],
  '107000': [destructive_x+125, destructive_y+45],
  '108000': [dark_x+125, dark_y+45],
  '109000': [racial_x+50, racial_y+68],
  '110000': [211, 68],
  '111000': [innates_x+120, innates_y+68],
  '112000': [innates_x+0, innates_y+26],
  '113000': [211, 68],
  '114000': [315, 68],
  '115000': [347, 68],
  '116000': [offence_x+150, offence_y+45],
  '117000': [innates_x+0, innates_y+68],
  '118000': [leadership_x+150, leadership_y+45],
  '119000': [racial_x+20, racial_y+68],
  '120000': [0, 0],
  '121000': [innates_x+0, innates_y+26],
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
  '133000': [shatter_x+30, shatter_y+45],
  '134000': [training_x+150, training_y+55],
  '135000': [training_x+150, training_y+35],
  '136000': [innates_x+0, innates_y+26],
  '137000': [innates_x+0, innates_y+68],
  '138000': [352, 68],
  '139000': [natural_x+150, natural_y+20],
  '140000': [sorcery_x+125, sorcery_y+45],
  '141000': [offence_x+55, offence_y+45],
  '142000': [242, 68],
  '143000': [321, 68],
  '144000': [290, 68],
  '145000': [214, 68],
  '146000': [innates_x+150, innates_y+68],
  '147000': [destructive_x+55, destructive_y+45],
  '148000': [sorcery_x+30, sorcery_y+45],
  '149000': [244, 68],
  '150000': [innates_x+0, innates_y+68],
  '151001': [racial_x+40, racial_y+26],
  '151002': [racial_x+70, racial_y+26],
  '151003': [racial_x+100, racial_y+26],
  '151004': [racial_x+130, racial_y+26],
  '152000': [212, 68],
  '153000': [242, 68],
  '154000': [183, 68],
  '155000': [sorcery_x+55, sorcery_y+45],
  '156000': [warfare_x+125, warfare_y+45],
  '157000': [293, 68],
  '158000': [324, 68],
  '159000': [shatter_x+150, shatter_y+55],
  '160000': [offence_x+5, offence_y+45],
  '161000': [defense_x+5, defense_y+45],
  '162000': [voice_x+150, voice_y+45],
  '163000': [destructive_x+30, destructive_y+45],
  '164000': [innates_x+0, innates_y+26],
  '165000': [light_x+150, light_y+45],
  '166000': [352, 68],
  '167000': [innates_x+0, innates_y+68],
  '168000': [logistics_x+55, logistics_y+45],
  '169000': [learning_x+55, learning_y+45],
  '170000': [211, 68],
  '171000': [defense_x+55, defense_y+45],
  '172001': [racial_x+40, racial_y+26],
  '172002': [racial_x+70, racial_y+26],
  '172003': [racial_x+100, racial_y+26],
  '172004': [racial_x+130, racial_y+26],
  '173000': [voice_x+100, voice_y+45],
  '174000': [183, 68],
  '175000': [combat_x+30, combat_y+45],
  '176000': [innates_x+0, innates_y+68],
  '177000': [logistics_x+150, logistics_y+45],
  '178000': [211, 68],
  '179000': [voice_x+125, voice_y+45],
  '180000': [combat_x+55, combat_y+55],
  '181000': [320, 68],
  '182000': [289, 68],
  '183000': [racial_x+120, racial_y+68],
  '184000': [240, 68],
  '185001': [training_x+45, training_y+10],
  '185002': [training_x+75, training_y+10],
  '185003': [training_x+105, training_y+10],
  '186000': [349, 68],
  '187001': [voice_x+45, voice_y+10],
  '187002': [voice_x+75, voice_y+10],
  '187003': [voice_x+105, voice_y+10],
  '188000': [voice_x+30, voice_y+45],
  '189000': [voice_x+5, voice_y+45],
  '190000': [voice_x+55, voice_y+45],
  '191000': [leadership_x+30, leadership_y+45],
  '192000': [leadership_x+55, leadership_y+45],
  '193000': [training_x+55, training_y+45],
  '194000': [light_x+125, light_y+45],
  '195000': [combat_x+100, combat_y+45],
  '196000': [combat_x+5, combat_y+45],
  '197000': [innates_x+0, innates_y+0],
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
  '205000': [innates_x+180, innates_y+26],
  '206000': [shatter_x+55, shatter_y+45],
  '207000': [shatter_x+100, shatter_y+45],
  '208000': [shatter_x+150, shatter_y+35],
  '209000': [shatter_x+125, shatter_y+35],
  '210000': [natural_x+5, natural_y+45],
  '211001': [despotism_x+45, despotism_y+10],
  '211002': [despotism_x+75, despotism_y+10],
  '211003': [despotism_x+105, despotism_y+10],
  '212000': [despotism_x+5, despotism_y+45],
  '213000': [despotism_x+30, despotism_y+45],
  '214000': [despotism_x+55, despotism_y+45],
  '215000': [innates_x+120, innates_y+26],
  '216000': [light_x+30, light_y+45],
  '217000': [racial_x+150, racial_y+68],
  '218000': [combat_x+55, combat_y+35],
  '219000': [combat_x+150, combat_y+35],
  '220000': [innates_x+210, innates_y+26],
  '221000': [training_x+100, training_y+45],
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
    elif "LungWorkout" in path:
        return 128
    return 64


for branch in branches[10:]:
    x = coordinates_branch[branch][0]
    y = coordinates_branch[branch][1]
    write_from_template("branch.(WindowSimple).xdb.j2", window_branch_path(branch), {'skill_name': branch, 'pos_x': x, 'pos_y': y})


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
