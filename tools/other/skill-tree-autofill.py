
import os
import xmltodict
from jinja2 import Environment, FileSystemLoader


root_data_path = "../../game_data/data"
skills_xdb_path = "../../game_data/data/GameMechanics/RefTables/Skills.xdb"
skill_tree_path = "../../game_data/skilltree/UI/Doc/Skills"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates"))

with open(skills_xdb_path, 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())


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


counter = -1
for skill in skills_data["Table_HeroSkill_SkillID"]["objects"]["Item"]:
    counter = counter + 1
    elements = {}
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
    else:
        id = f"{counter:03}000"
        elements[id] = {
            'icon': skill["obj"]["Texture"]["Item"][1]["@href"],
            'name': skill["obj"]["NameFileRef"]["Item"]["@href"],
            'desc': skill["obj"]["DescriptionFileRef"]["Item"]["@href"],
        }
    for id in elements:
        faction = "Common"
        if os.path.isfile(button_base_path(id, faction)):
            print(f"Processing ID {id}...")
            with open(button_base_path(id, faction)) as button_base_xdb:
                button_data = xmltodict.parse(button_base_xdb.read())
                x = button_data["WindowMSButton"]["Placement"]["Position"]["First"]["x"]
                y = button_data["WindowMSButton"]["Placement"]["Position"]["First"]["y"]
            write_from_template("buttonshared.(WindowMSButtonShared).xdb.j2", button_shared_path(id, faction), {'skill_id': id})
            write_from_template("selection.(WindowMSButton).xdb.j2", button_selected_path(id), {'skill_id': id, 'pos_x': x, 'pos_y': y})
            write_from_template("uimessage1.(UISSendUIMessage).xdb.j2", ui_message_up_path(id), {'skill_id': id})
            write_from_template("uimessage2.(UISSendUIMessage).xdb.j2", ui_message_down_path(id), {'skill_id': id})
            write_from_template("descuimessage.(UISSendUIMessage).xdb.j2", desc_ui_message_path(id), {'skill_id': id})
            write_from_template("windowbase.(WindowSimple).xdb.j2", desc_window_base_path(id), {'skill_id': id})
            write_from_template("windowshared.(WindowSimpleShared).xdb.j2", desc_window_shared_path(id), {'skill_id': id})
            write_from_template("iconbase.(WindowMSButton).xdb.j2", desc_icon_base_path(id), {'skill_id': id})
            write_from_template("iconshared.(WindowMSButtonShared).xdb.j2", desc_icon_shared_path(id), {'skill_id': id})
            write_from_template("icon.(BackgroundSimpleScallingTexture).xdb.j2", desc_icon_path(id), {'icon_path': elements[id]['icon']})
            write_from_template("skillname.(WindowTextView).xdb.j2", skill_name_path(id), {'skill_id': id, 'name_path': elements[id]['name']})
            write_from_template("skilldesc.(WindowTextView).xdb.j2", skill_desc_path(id), {'skill_id': id, 'desc_path': elements[id]['desc']})
        else:
            print(f"WARN: missing button file for ID {id}")
