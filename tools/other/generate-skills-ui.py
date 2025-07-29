
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
  '001001': [238, 468],
  '001002': [267, 468],
  '001003': [296, 468],
  '002001': [430, 225],
  '002002': [457, 225],
  '002003': [485, 225],
  '003001': [240, 225],
  '003002': [266, 225],
  '003003': [294, 225],
  '004000': [479, 345],
  '005000': [119, 182],
  '006001': [46, 144],
  '006002': [74, 144],
  '006003': [102, 144],
  '007001': [241, 144],
  '007002': [268, 144],
  '007003': [294, 144],
  '008001': [46, 225],
  '008002': [73, 225],
  '008003': [101, 225],
  '009001': [240, 387],
  '009002': [267, 387],
  '009003': [295, 387],
  '010001': [241, 306],
  '010002': [268, 306],
  '010003': [295, 306],
  '011001': [46, 306],
  '011002': [74, 306],
  '011003': [103, 306],
  '012001': [45, 387],
  '012002': [74, 387],
  '012003': [103, 387],
  '013001': [430, 144],
  '013002': [458, 144],
  '013003': [485, 144],
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
  '019000': [194, 506],
  '020000': [220, 506],
  '021001': [45, 468],
  '021002': [74, 468],
  '021003': [103, 468],
  '022000': [479, 266],
  '023000': [390, 266],
  '024000': [530, 266],
  '026000': [221, 265],
  '027000': [194, 265],
  '028000': [290, 506],
  '029000': [5, 508],
  '030000': [392, 345],
  '031000': [508, 507],
  '032000': [484, 507],
  '033000': [31, 508],
  '034000': [30, 182],
  '035000': [94, 182],
  '036000': [418, 507],
  '037000': [482, 426],
  '038000': [290, 182],
  '039000': [393, 507],
  '040000': [149, 265],
  '041000': [95, 265],
  '042000': [6, 265],
  '043000': [286, 426],
  '044000': [194, 426],
  '045000': [134, 26],
  '046000': [192, 345],
  '047000': [164, 26],
  '048000': [287, 345],
  '049000': [194, 26],
  '050000': [3, 345],
  '051000': [95, 345],
  '052000': [104, 68],
  '053000': [92, 426],
  '055000': [320, 68],
  '056000': [183, 68],
  '057000': [289, 68],
  '058000': [217, 345],
  '059000': [294, 68],
  '060000': [508, 182],
  '061001': [220, 26],
  '061002': [250, 26],
  '061003': [280, 26],
  '061004': [310, 26],
  '062000': [105, 65],
  '063000': [181, 68],
  '065000': [286, 68],
  '066000': [182, 68],
  '067000': [211, 68],
  '068000': [183, 68],
  '069000': [240, 68],
  '070000': [183, 68],
  '071000': [342, 265],
  '072000': [105, 65],
  '073000': [104, 26],
  '074000': [442, 266],
  '075000': [504, 345],
  '076000': [104, 68],
  '077000': [222, 182],
  '078000': [240, 68],
  '079000': [134, 68],
  '080000': [57, 508],
  '081000': [104, 26],
  '082000': [354, 68],
  '083000': [243, 345],
  '084000': [118, 426],
  '085000': [349, 68],
  '086000': [183, 68],
  '087000': [313, 265],
  '088000': [147, 420],
  '089000': [211, 68],
  '090000': [241, 68],
  '091000': [533, 182],
  '092000': [104, 26],
  '093000': [490, 68],
  '094000': [324, 68],
  '096000': [164, 68],
  '097000': [147, 440],
  '098000': [513, 65],
  '099000': [194, 68],
  '100000': [342, 345],
  '101000': [243, 68],
  '102000': [357, 68],
  '103000': [514, 65],
  '104000': [340, 426],
  '105000': [295, 68],
  '106000': [327, 68],
  '107000': [314, 426],
  '108000': [315, 345],
  '109000': [135, 26],
  '110000': [211, 68],
  '111000': [224, 68],
  '112000': [106, 65],
  '113000': [211, 68],
  '114000': [315, 68],
  '115000': [347, 68],
  '116000': [144, 182],
  '117000': [514, 65],
  '118000': [530, 345],
  '119000': [430, 68],
  '120000': [224, 26],
  '121000': [106, 65],
  '122000': [56, 426],
  '123000': [31, 426],
  '124001': [430, 26],
  '124002': [460, 26],
  '124003': [490, 26],
  '125000': [320, 68],
  '126000': [349, 68],
  '128000': [289, 68],
  '129000': [315, 506],
  '130000': [416, 266],
  '131000': [316, 182],
  '132000': [56, 345],
  '133000': [507, 426],
  '134000': [533, 413],
  '135000': [533, 435],
  '136000': [460, 68],
  '137000': [104, 68],
  '138000': [352, 68],
  '139000': [147, 401],
  '141000': [57, 182],
  '142000': [242, 68],
  '143000': [321, 68],
  '144000': [290, 68],
  '145000': [214, 68],
  '146000': [254, 68],
  '147000': [245, 426],
  '148000': [32, 265],
  '149000': [244, 68],
  '150000': [512, 65],
  '151001': [220, 26],
  '151002': [250, 26],
  '151003': [280, 26],
  '151004': [310, 26],
  '152000': [212, 68],
  '153000': [242, 68],
  '154000': [183, 68],
  '155000': [59, 265],
  '156000': [504, 266],
  '157000': [293, 68],
  '158000': [324, 68],
  '159000': [532, 507],
  '160000': [4, 182],
  '161000': [195, 182],
  '162000': [314, 89],
  '163000': [218, 426],
  '164000': [107, 65],
  '165000': [145, 345],
  '166000': [352, 68],
  '167000': [514, 65],
  '168000': [248, 506],
  '169000': [246, 265],
  '170000': [211, 68],
  '171000': [248, 182],
  '172001': [220, 26],
  '172002': [250, 26],
  '172003': [280, 26],
  '172004': [310, 26],
  '173000': [286, 89],
  '174000': [183, 68],
  '175000': [416, 182],
  '176000': [104, 68],
  '177000': [340, 506],
  '178000': [211, 68],
  '179000': [341, 89],
  '180000': [443, 182],
  '181000': [320, 68],
  '182000': [289, 68],
  '183001': [0, 0],
  '183002': [0, 0],
  '183003': [0, 0],
  '184000': [240, 68],
  '185001': [429, 468],
  '185002': [456, 468],
  '185003': [483, 468],
  '186000': [349, 68],
  '187001': [441, 26],
  '187002': [472, 26],
  '187003': [503, 26],
  '188000': [411, 68],
  '189000': [465, 68],
  '190000': [438, 68],
  '191000': [417, 345],
  '192000': [442, 345],
  '193000': [442, 507],
  '194000': [119, 345],
  '195000': [481, 182],
  '196000': [389, 182],
  '197000': [254, 26],
  '198001': [429, 306],
  '198002': [458, 306],
  '198003': [486, 306],
  '199001': [431, 387],
  '199002': [459, 387],
  '199003': [486, 387],
  '200000': [95, 508],
  '201000': [119, 508],
  '202000': [145, 508],
  '203000': [147, 383],
  '204000': [343, 182],
  '205000': [284, 26],
  '206000': [444, 426],
  '207000': [391, 426],
  '209000': [284, 68],
  '210000': [4, 426],
  '212000': [286, 265],
  '216000': [28, 345],
  '217000': [417, 426],
  '219000': [122, 265],
  '220000': [104, 26],
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
