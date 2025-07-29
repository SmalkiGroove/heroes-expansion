
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
  '001001': [218, 468],
  '001002': [247, 468],
  '001003': [276, 468],
  '002001': [410, 225],
  '002002': [437, 225],
  '002003': [465, 225],
  '003001': [220, 225],
  '003002': [246, 225],
  '003003': [274, 225],
  '004000': [459, 345],
  '005000': [99, 182],
  '006001': [26, 144],
  '006002': [54, 144],
  '006003': [82, 144],
  '007001': [221, 144],
  '007002': [248, 144],
  '007003': [274, 144],
  '008001': [26, 225],
  '008002': [53, 225],
  '008003': [81, 225],
  '009001': [220, 387],
  '009002': [247, 387],
  '009003': [275, 387],
  '010001': [221, 306],
  '010002': [248, 306],
  '010003': [275, 306],
  '011001': [26, 306],
  '011002': [54, 306],
  '011003': [83, 306],
  '012001': [25, 387],
  '012002': [54, 387],
  '012003': [83, 387],
  '013001': [410, 144],
  '013002': [438, 144],
  '013003': [465, 144],
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
  '019000': [174, 506],
  '020000': [200, 506],
  '021001': [25, 468],
  '021002': [54, 468],
  '021003': [83, 468],
  '022000': [459, 266],
  '023000': [370, 266],
  '024000': [510, 266],
  '026000': [201, 265],
  '027000': [174, 265],
  '028000': [270, 506],
  '029000': [-15, 508],
  '030000': [372, 345],
  '031000': [488, 507],
  '032000': [464, 507],
  '033000': [11, 508],
  '034000': [10, 182],
  '035000': [74, 182],
  '036000': [398, 507],
  '037000': [462, 426],
  '038000': [270, 182],
  '039000': [373, 507],
  '040000': [129, 265],
  '041000': [75, 265],
  '042000': [-14, 265],
  '043000': [266, 426],
  '044000': [174, 426],
  '046000': [172, 345],
  '048000': [267, 345],
  '050000': [-17, 345],
  '051000': [75, 345],
  '053000': [72, 426],
  '055000': [300, 68],
  '056000': [163, 68],
  '057000': [269, 68],
  '058000': [197, 345],
  '059000': [274, 68],
  '060000': [488, 182],
  '061001': [200, 26],
  '061002': [230, 26],
  '061003': [260, 26],
  '061004': [290, 26],
  '062000': [85, 65],
  '063000': [161, 68],
  '065000': [266, 68],
  '066000': [162, 68],
  '067000': [191, 68],
  '068000': [163, 68],
  '069000': [220, 68],
  '070000': [163, 68],
  '071000': [322, 265],
  '072000': [85, 65],
  '073000': [84, 26],
  '074000': [422, 266],
  '075000': [484, 345],
  '076000': [84, 68],
  '077000': [202, 182],
  '078000': [220, 68],
  '080000': [37, 508],
  '081000': [84, 26],
  '082000': [334, 68],
  '083000': [223, 345],
  '084000': [98, 426],
  '085000': [329, 68],
  '086000': [163, 68],
  '087000': [293, 265],
  '088000': [127, 420],
  '089000': [191, 68],
  '090000': [221, 68],
  '091000': [513, 182],
  '092000': [84, 26],
  '093000': [470, 68],
  '094000': [304, 68],
  '097000': [127, 440],
  '098000': [493, 65],
  '100000': [322, 345],
  '101000': [223, 68],
  '102000': [337, 68],
  '103000': [494, 65],
  '104000': [320, 426],
  '105000': [275, 68],
  '106000': [307, 68],
  '107000': [294, 426],
  '108000': [295, 345],
  '109000': [115, 26],
  '110000': [191, 68],
  '112000': [86, 65],
  '113000': [191, 68],
  '114000': [295, 68],
  '115000': [327, 68],
  '116000': [124, 182],
  '117000': [494, 65],
  '118000': [510, 345],
  '119000': [410, 68],
  '121000': [86, 65],
  '122000': [36, 426],
  '123000': [11, 426],
  '124001': [410, 26],
  '124002': [440, 26],
  '124003': [470, 26],
  '125000': [300, 68],
  '126000': [329, 68],
  '128000': [269, 68],
  '129000': [295, 506],
  '130000': [396, 266],
  '131000': [296, 182],
  '132000': [36, 345],
  '133000': [487, 426],
  '134000': [513, 413],
  '135000': [513, 435],
  '136000': [440, 68],
  '137000': [84, 68],
  '138000': [332, 68],
  '139000': [127, 401],
  '141000': [37, 182],
  '142000': [222, 68],
  '143000': [301, 68],
  '144000': [270, 68],
  '145000': [194, 68],
  '147000': [225, 426],
  '148000': [12, 265],
  '149000': [224, 68],
  '150000': [492, 65],
  '151001': [200, 26],
  '151002': [230, 26],
  '151003': [260, 26],
  '151004': [290, 26],
  '152000': [192, 68],
  '153000': [222, 68],
  '154000': [163, 68],
  '155000': [39, 265],
  '156000': [484, 266],
  '157000': [273, 68],
  '158000': [304, 68],
  '159000': [512, 507],
  '160000': [-16, 182],
  '161000': [175, 182],
  '162000': [294, 89],
  '163000': [198, 426],
  '164000': [87, 65],
  '165000': [125, 345],
  '166000': [332, 68],
  '167000': [494, 65],
  '168000': [228, 506],
  '169000': [226, 265],
  '170000': [191, 68],
  '171000': [228, 182],
  '172001': [200, 26],
  '172002': [230, 26],
  '172003': [260, 26],
  '172004': [290, 26],
  '173000': [266, 89],
  '174000': [163, 68],
  '175000': [396, 182],
  '176000': [84, 68],
  '177000': [320, 506],
  '178000': [191, 68],
  '179000': [321, 89],
  '180000': [423, 182],
  '181000': [300, 68],
  '182000': [269, 68],
  '183001': [-39, 47],
  '183002': [0, 0],
  '183003': [167, 81],
  '184000': [220, 68],
  '185001': [409, 468],
  '185002': [436, 468],
  '185003': [463, 468],
  '186000': [329, 68],
  '187001': [421, 26],
  '187002': [452, 26],
  '187003': [483, 26],
  '188000': [391, 68],
  '189000': [445, 68],
  '190000': [418, 68],
  '191000': [397, 345],
  '192000': [422, 345],
  '193000': [422, 507],
  '194000': [99, 345],
  '195000': [461, 182],
  '196000': [369, 182],
  '198001': [409, 306],
  '198002': [438, 306],
  '198003': [466, 306],
  '199001': [411, 387],
  '199002': [439, 387],
  '199003': [466, 387],
  '200000': [75, 508],
  '201000': [99, 508],
  '202000': [125, 508],
  '203000': [127, 383],
  '204000': [323, 182],
  '206000': [424, 426],
  '207000': [371, 426],
  '210000': [-16, 426],
  '212000': [266, 265],
  '216000': [8, 345],
  '217000': [397, 426],
  '219000': [102, 265],
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
    return os.path.join(skill_tree_path, "_Selection", id, f"{id}_select.(WindowMSButton).xdb")
def ui_message_up_path(id):
    return os.path.join(skill_tree_path, "_Selection", id, f"{id}_up.(UISSendUIMessage).xdb")
def ui_message_down_path(id):
    return os.path.join(skill_tree_path, "_Selection", id, f"{id}_down.(UISSendUIMessage).xdb")
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


factions = ["Common", "Haven", "Preserve", "Fortress", "Academy", "Dungeon", "Necro", "Inferno", "Stronghold", "Neutral"]

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
                directories = {
                    os.path.join(skill_tree_path, "_Selection", id),
                    os.path.join(skill_tree_path, "_Description", id),
                }
                for targetDir in directories:
                    if not os.path.exists(targetDir):
                        os.makedirs(targetDir)
                dirrm = os.path.join(skill_tree_path, faction, id, "selection")
                if os.path.exists(dirrm):
                    for file in os.listdir(dirrm):
                        os.remove(os.path.join(dirrm, file))
                    os.rmdir(dirrm)
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
