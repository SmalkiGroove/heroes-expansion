
import os
import xmltodict
from jinja2 import Environment, FileSystemLoader

root_text_path = "../../game_texts/texts-EN"
root_data_path = "../../game_data/data"
skills_xdb_path = "../../game_data/data/GameMechanics/RefTables/Skills.xdb"
skill_tree_path = "../../game_data/doc/UI/Doc/Skills"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates"))

with open(skills_xdb_path, 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())

all_buttons = open("out_buttons.xml", 'w')
all_selected = open("out_selected.xml", 'w')
all_windows = open("out_windows.xml", 'w')

coordinates = {
  '001001': [338, 588],
  '001002': [367, 588],
  '001003': [396, 588],
  '002001': [530, 345],
  '002002': [557, 345],
  '002003': [585, 345],
  '003001': [340, 345],
  '003002': [366, 345],
  '003003': [394, 345],
  '004000': [579, 465],
  '005000': [219, 302],
  '006001': [146, 264],
  '006002': [174, 264],
  '006003': [202, 264],
  '007001': [341, 264],
  '007002': [368, 264],
  '007003': [394, 264],
  '008001': [146, 345],
  '008002': [173, 345],
  '008003': [201, 345],
  '009001': [340, 507],
  '009002': [367, 507],
  '009003': [395, 507],
  '010001': [341, 426],
  '010002': [368, 426],
  '010003': [395, 426],
  '011001': [146, 426],
  '011002': [174, 426],
  '011003': [203, 426],
  '012001': [145, 507],
  '012002': [174, 507],
  '012003': [203, 507],
  '013001': [530, 264],
  '013002': [558, 264],
  '013003': [585, 264],
  '014001': [200, 26],
  '014002': [230, 26],
  '014003': [260, 26],
  '014004': [290, 26],
  '015001': [200, 26],
  '015002': [230, 26],
  '015003': [260, 26],
  '015004': [290, 26],
  '016001': [200, 26],
  '016002': [230, 26],
  '016003': [260, 26],
  '016004': [290, 26],
  '017001': [200, 26],
  '017002': [230, 26],
  '017003': [260, 26],
  '017004': [290, 26],
  '018001': [200, 26],
  '018002': [230, 26],
  '018003': [260, 26],
  '018004': [290, 26],
  '019000': [294, 626],
  '020000': [320, 626],
  '021001': [145, 588],
  '021002': [174, 588],
  '021003': [203, 588],
  '022000': [579, 386],
  '023000': [490, 386],
  '024000': [630, 386],
  '026000': [321, 385],
  '027000': [294, 385],
  '028000': [390, 626],
  '029000': [105, 628],
  '030000': [492, 465],
  '031000': [608, 627],
  '032000': [584, 627],
  '033000': [131, 628],
  '034000': [130, 302],
  '035000': [194, 302],
  '036000': [518, 627],
  '037000': [582, 546],
  '038000': [390, 302],
  '039000': [493, 627],
  '040000': [249, 385],
  '041000': [195, 385],
  '042000': [106, 385],
  '043000': [386, 546],
  '044000': [294, 546],
  '046000': [292, 465],
  '048000': [387, 465],
  '050000': [103, 465],
  '051000': [195, 465],
  '053000': [192, 546],
  '055000': [300, 68],
  '056000': [163, 68],
  '057000': [269, 68],
  '058000': [317, 465],
  '059000': [394, 188],
  '060000': [608, 302],
  '061001': [200, 26],
  '061002': [230, 26],
  '061003': [260, 26],
  '061004': [290, 26],
  '062000': [205, 185],
  '063000': [281, 188],
  '065000': [386, 188],
  '066000': [282, 188],
  '067000': [191, 68],
  '068000': [163, 68],
  '069000': [220, 68],
  '070000': [283, 188],
  '071000': [442, 385],
  '072000': [205, 185],
  '073000': [84, 26],
  '074000': [542, 386],
  '075000': [604, 465],
  '076000': [84, 68],
  '077000': [322, 302],
  '078000': [220, 68],
  '080000': [157, 628],
  '081000': [84, 26],
  '082000': [454, 188],
  '083000': [343, 465],
  '084000': [218, 546],
  '085000': [329, 68],
  '086000': [283, 188],
  '087000': [413, 385],
  '088000': [247, 540],
  '089000': [311, 188],
  '090000': [341, 188],
  '091000': [633, 302],
  '092000': [84, 26],
  '093000': [470, 68],
  '094000': [424, 188],
  '097000': [247, 560],
  '098000': [613, 185],
  '100000': [442, 465],
  '101000': [343, 188],
  '102000': [457, 188],
  '103000': [614, 185],
  '104000': [440, 546],
  '105000': [395, 188],
  '106000': [427, 188],
  '107000': [414, 546],
  '108000': [415, 465],
  '109000': [115, 26],
  '110000': [311, 188],
  '112000': [206, 185],
  '113000': [311, 188],
  '114000': [415, 188],
  '115000': [447, 188],
  '116000': [244, 302],
  '117000': [614, 185],
  '118000': [630, 465],
  '119000': [410, 68],
  '121000': [206, 185],
  '122000': [156, 546],
  '123000': [131, 546],
  '124001': [410, 26],
  '124002': [440, 26],
  '124003': [470, 26],
  '125000': [300, 68],
  '126000': [329, 68],
  '128000': [269, 68],
  '129000': [415, 626],
  '130000': [516, 386],
  '131000': [416, 302],
  '132000': [156, 465],
  '133000': [607, 546],
  '134000': [633, 533],
  '135000': [633, 555],
  '136000': [440, 68],
  '137000': [84, 68],
  '138000': [452, 188],
  '139000': [247, 521],
  '141000': [157, 302],
  '142000': [342, 188],
  '143000': [421, 188],
  '144000': [390, 188],
  '145000': [314, 188],
  '147000': [345, 546],
  '148000': [132, 385],
  '149000': [344, 188],
  '150000': [612, 185],
  '151001': [200, 26],
  '151002': [230, 26],
  '151003': [260, 26],
  '151004': [290, 26],
  '152000': [312, 188],
  '153000': [342, 188],
  '154000': [283, 188],
  '155000': [159, 385],
  '156000': [604, 386],
  '157000': [393, 188],
  '158000': [424, 188],
  '159000': [632, 627],
  '160000': [104, 302],
  '161000': [295, 302],
  '162000': [294, 89],
  '163000': [318, 546],
  '164000': [207, 185],
  '165000': [245, 465],
  '166000': [452, 188],
  '167000': [614, 185],
  '168000': [348, 626],
  '169000': [346, 385],
  '170000': [191, 68],
  '171000': [348, 302],
  '172001': [200, 26],
  '172002': [230, 26],
  '172003': [260, 26],
  '172004': [290, 26],
  '173000': [266, 89],
  '174000': [163, 68],
  '175000': [516, 302],
  '176000': [84, 68],
  '177000': [440, 626],
  '178000': [191, 68],
  '179000': [321, 89],
  '180000': [543, 302],
  '181000': [300, 68],
  '182000': [269, 68],
  '183001': [81, 167],
  '183002': [120, 120],
  '183003': [167, 81],
  '184000': [220, 68],
  '185001': [529, 588],
  '185002': [556, 588],
  '185003': [583, 588],
  '186000': [329, 68],
  '187001': [421, 26],
  '187002': [452, 26],
  '187003': [483, 26],
  '188000': [391, 68],
  '189000': [445, 68],
  '190000': [418, 68],
  '191000': [517, 465],
  '192000': [542, 465],
  '193000': [542, 627],
  '194000': [219, 465],
  '195000': [581, 302],
  '196000': [489, 302],
  '198001': [529, 426],
  '198002': [558, 426],
  '198003': [586, 426],
  '199001': [531, 507],
  '199002': [559, 507],
  '199003': [586, 507],
  '200000': [195, 628],
  '201000': [219, 628],
  '202000': [245, 628],
  '203000': [247, 503],
  '204000': [443, 302],
  '206000': [544, 546],
  '207000': [491, 546],
  '210000': [104, 546],
  '212000': [386, 385],
  '216000': [128, 465],
  '217000': [517, 546],
  '219000': [222, 385],
  '220000': [84, 26],
}

def button_base_path(id, faction):
    return os.path.join(skill_tree_path, faction, id, f"{id}.(WindowMSButton).xdb")
def button_shared_path(id, faction):
    return os.path.join(skill_tree_path, faction, id, f"{id}.(WindowMSButtonShared).xdb")
def button_bgwindow_path(id, faction):
    return os.path.join(skill_tree_path, faction, id, f"{id}_icon.(WindowSimple).xdb")
def button_bgshared_path(id, faction):
    return os.path.join(skill_tree_path, faction, id, f"{id}_icon.(WindowSimpleShared).xdb")
def button_background_path(id, faction):
    return os.path.join(skill_tree_path, faction, id, f"{id}.(BackgroundSimpleScallingTexture).xdb")
def button_selected_path(id):
    return os.path.join(skill_tree_path, faction, id, "selection", f"{id}_select.(WindowMSButton).xdb")
def ui_message_up_path(id):
    return os.path.join(skill_tree_path, faction, id, "selection", f"{id}_up.(UISSendUIMessage).xdb")
def ui_message_down_path(id):
    return os.path.join(skill_tree_path, faction, id, "selection", f"{id}_down.(UISSendUIMessage).xdb")
def desc_ui_message_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}.(UISSendUIMessage).xdb")
def desc_window_base_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_window.(WindowSimple).xdb")
def desc_window_shared_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_window.(WindowSimpleShared).xdb")
def desc_icon_base_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_icon.(WindowMSButton).xdb")
def desc_icon_shared_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_icon.(WindowMSButtonShared).xdb")
def desc_icon_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_icon.(BackgroundSimpleScallingTexture).xdb")
def skill_name_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_name.(WindowTextView).xdb")
def skill_desc_path(id):
    return os.path.join(skill_tree_path, "_Description", id, f"{id}_desc.(WindowTextView).xdb")

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


factions = ["Common", "Haven", "Preserve", "Fortress", "Academy", "Dungeon", "Necro", "Inferno", "Stronghold"]

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
                x = coordinates[id][0]
                y = coordinates[id][1]
                icon_size = find_icon_size(elements[id]['icon'])
                directories = {os.path.join(skill_tree_path, faction, id, "selection")}
                for targetDir in directories:
                    if not os.path.exists(targetDir):
                        os.makedirs(targetDir)
                write_from_template("button.(WindowMSButton).xdb.j2", button_base_path(id, faction), {'skill_id': id, 'pos_x': x, 'pos_y': y})
                write_from_template("buttonshared.(WindowMSButtonShared).xdb.j2", button_shared_path(id, faction), {'skill_id': id, 'required_skills': prerequisites[id], 'icon_path': elements[id]['icon']})
                write_from_template("skillicon.(WindowSimple).xdb.j2", button_bgwindow_path(id, faction), {'skill_id': id})
                write_from_template("skillicon.(WindowSimpleShared).xdb.j2", button_bgshared_path(id, faction), {'skill_id': id})
                write_from_template("icon.(BackgroundSimpleScallingTexture).xdb.j2", button_background_path(id, faction), {'icon_path': elements[id]['icon'], 'icon_size': icon_size})
                write_from_template("selection.(WindowMSButton).xdb.j2", button_selected_path(id), {'skill_id': id, 'pos_x': x, 'pos_y': y})
                write_from_template("uimessage1.(UISSendUIMessage).xdb.j2", ui_message_up_path(id), {'skill_id': id})
                write_from_template("uimessage2.(UISSendUIMessage).xdb.j2", ui_message_down_path(id), {'skill_id': id})
                write_from_template("descuimessage.(UISSendUIMessage).xdb.j2", desc_ui_message_path(id), {'skill_id': id})
                write_from_template("windowbase.(WindowSimple).xdb.j2", desc_window_base_path(id), {'skill_id': id})
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", desc_window_shared_path(id), {'skill_id': id})
                write_from_template("iconbase.(WindowMSButton).xdb.j2", desc_icon_base_path(id), {'skill_id': id})
                write_from_template("iconshared.(WindowMSButtonShared).xdb.j2", desc_icon_shared_path(id), {'skill_id': id})
                write_from_template("icon.(BackgroundSimpleScallingTexture).xdb.j2", desc_icon_path(id), {'icon_path': elements[id]['icon'], 'icon_size': icon_size})
                write_from_template("skillname.(WindowTextView).xdb.j2", skill_name_path(id), {'skill_id': id, 'name_path': elements[id]['name']})
                write_from_template("skilldesc.(WindowTextView).xdb.j2", skill_desc_path(id), {'skill_id': id, 'desc_path': elements[id]['desc']})
                all_buttons.write(f"<Item href=\"/UI/Doc/Skills/{faction}/{id}/{id}.(WindowMSButton).xdb#xpointer(/WindowMSButton)\"/>\n")
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
