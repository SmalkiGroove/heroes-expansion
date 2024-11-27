
import os
import xmltodict
from jinja2 import Environment, FileSystemLoader


root_data_path = "../../game_data/data"
skills_xdb_path = "../../game_data/data/GameMechanics/RefTables/Skills.xdb"
skill_tree_path = "../../game_data/doc/UI/Doc/Skills"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates"))

with open(skills_xdb_path, 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())

all_buttons = open("out_buttons.xml", 'w')
all_selected = open("out_selected.xml", 'w')
all_windows = open("out_windows.xml", 'w')

def button_base_path(id, faction):
    return os.path.join(skill_tree_path, faction, f"{id}.(WindowMSButton).xdb")
def button_shared_path(id, faction):
    return os.path.join(skill_tree_path, faction, f"{id}.(WindowMSButtonShared).xdb")
def button_selected_path(id):
    return os.path.join(skill_tree_path, "Selection", f"{id}_select.(WindowMSButton).xdb")
def ui_message_up_path(id):
    return os.path.join(skill_tree_path, "Selection", f"{id}_up.(UISSendUIMessage).xdb")
def ui_message_down_path(id):
    return os.path.join(skill_tree_path, "Selection", f"{id}_down.(UISSendUIMessage).xdb")
def desc_ui_message_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}.(UISSendUIMessage).xdb")
def desc_window_base_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_window.(WindowSimple).xdb")
def desc_window_shared_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_window.(WindowSimpleShared).xdb")
def desc_icon_base_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_icon.(WindowMSButton).xdb")
def desc_icon_shared_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_icon.(WindowMSButtonShared).xdb")
def desc_icon_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_icon.(BackgroundSimpleScallingTexture).xdb")
def skill_name_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_name.(WindowTextView).xdb")
def skill_desc_path(id):
    return os.path.join(skill_tree_path, "Description", f"{id}_desc.(WindowTextView).xdb")

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


factions = ["Common", "knight", "ranger", "runemage", "wizard", "warlock", "necro", "demon", "barbarian"]

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
        for faction in factions:
            if os.path.isfile(button_base_path(id, faction)):
                print(f"Processing ID {id}...")
                if found:
                    print(f"WARN: found duplicate button file for ID {id}")
                    continue
                else:
                    found = True
                with open(button_base_path(id, faction)) as button_base_xdb:
                    button_data = xmltodict.parse(button_base_xdb.read())
                    x = button_data["WindowMSButton"]["Placement"]["Position"]["First"]["x"]
                    y = button_data["WindowMSButton"]["Placement"]["Position"]["First"]["y"]
                write_from_template("buttonshared.(WindowMSButtonShared).xdb.j2", button_shared_path(id, faction), {'skill_id': id, 'required_skills': prerequisites[id]})
                write_from_template("selection.(WindowMSButton).xdb.j2", button_selected_path(id), {'skill_id': id, 'pos_x': x, 'pos_y': y})
                write_from_template("uimessage1.(UISSendUIMessage).xdb.j2", ui_message_up_path(id), {'skill_id': id})
                write_from_template("uimessage2.(UISSendUIMessage).xdb.j2", ui_message_down_path(id), {'skill_id': id})
                write_from_template("descuimessage.(UISSendUIMessage).xdb.j2", desc_ui_message_path(id), {'skill_id': id})
                write_from_template("windowbase.(WindowSimple).xdb.j2", desc_window_base_path(id), {'skill_id': id})
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", desc_window_shared_path(id), {'skill_id': id})
                write_from_template("iconbase.(WindowMSButton).xdb.j2", desc_icon_base_path(id), {'skill_id': id})
                write_from_template("iconshared.(WindowMSButtonShared).xdb.j2", desc_icon_shared_path(id), {'skill_id': id})
                write_from_template("icon.(BackgroundSimpleScallingTexture).xdb.j2", desc_icon_path(id), {'icon_path': elements[id]['icon'], 'icon_size': find_icon_size(elements[id]['icon'])})
                write_from_template("skillname.(WindowTextView).xdb.j2", skill_name_path(id), {'skill_id': id, 'name_path': elements[id]['name']})
                write_from_template("skilldesc.(WindowTextView).xdb.j2", skill_desc_path(id), {'skill_id': id, 'desc_path': elements[id]['desc']})
                all_buttons.write(f"<Item href=\"/UI/Doc/Skills/{faction}/{id}.(WindowMSButton).xdb#xpointer(/WindowMSButton)\"/>\n")
                all_selected.write(f"<Item href=\"{id}_select.(WindowMSButton).xdb#xpointer(/WindowMSButton)\"/>\n")
                all_windows.write(f"<Item href=\"{id}_window.(WindowSimple).xdb#xpointer(/WindowSimple)\"/>\n")
        if not found:
            print(f"WARN: missing button file for ID {id}")

all_buttons.close()
all_selected.close()
all_windows.close()
