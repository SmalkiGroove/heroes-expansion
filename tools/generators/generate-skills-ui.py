"""Generates the Skills tab of the encyclopedia (game_data/www-skills/UI/Doc/Skills).

A skill or perk is generated only when its folder _Skills/<Branch>/<ID>/ exists: create the
empty folder to place an element in a branch, and give it coordinates in coordinates_skills.
IDs are <index in Skills.xdb on 3 digits><rank on 3 digits>, rank 000 being a perk.
"""

import os
import re
from collections import defaultdict
from common import Generator, GAME_DATA, TEXTS_EN, warn, load_xdb, as_list, items, href_path, game_file, find_icon_size

gen = Generator("templates-skills", __doc__)

skills_pedia_path = os.path.join(GAME_DATA, "www-skills", "UI", "Doc", "Skills")
skills_data = as_list(load_xdb(GAME_DATA, "skills", "GameMechanics", "RefTables", "Skills.xdb")["Table_HeroSkill_SkillID"]["objects"]["Item"])

racial_branches = ["Courage", "Avenger", "Runelore", "Artificier", "Arcanism", "Necromancy", "Gating", "BloodRage", "Spiritism"]
branches = ["Innates"] + racial_branches + [
            "Offence", "Defense", "Learning", "Sorcery", "LightMagic", "DarkMagic", "DestructiveMagic", "NaturalMagic",
            "Combat", "Leadership", "Logistics", "Warfare", "ShatterMagic", "Governance", "Training", "Despotism", "Voice"]
# Branches whose 4 elemental perks are ordered differently per faction, with one folder per order
variants = ['a', 'b', 'c', 'd']
variant_branches = ["DestructiveMagic", "NaturalMagic"]

# Children listed before the skills of a branch, and skills of other branches displayed in it
racial_labels = [
    "/UI/Doc/Skills/Common/LabelInnate.(WindowTextView).xdb#xpointer(/WindowTextView)",
    "/UI/Doc/Skills/Common/LabelUltimate.(WindowTextView).xdb#xpointer(/WindowTextView)",
]
branch_header = {branch: racial_labels for branch in racial_branches}
branch_extra = {"Spiritism": [("BloodRage", "176000")]}

# Position of each branch window (racial branch windows are hand-made)
coordinates_branch = {
    "Logistics": [0, 0], "ShatterMagic": [190, 0], "Combat": [380, 0],
    "Warfare": [0, 80], "LightMagic": [190, 80], "Offence": [380, 80],
    "Governance": [0, 160], "DarkMagic": [190, 160], "Defense": [380, 160],
    "Leadership": [0, 240], "NaturalMagic": [190, 240], "Learning": [380, 240],
    "Training": [0, 320], "DestructiveMagic": [190, 320], "Sorcery": [380, 320],
    "Voice": [380, 320], "Despotism": [0, 320],
    "Innates": [104, 0], "Racial": [180, 0],
}
# Origin of the skill coordinates inside each branch window
coordinates_relative = {
    "Logistics": [0, 0], "ShatterMagic": [0, 0], "Combat": [0, 0],
    "Warfare": [0, 0], "LightMagic": [0, 0], "Offence": [0, 0],
    "Governance": [0, 0], "DarkMagic": [0, 0], "Defense": [0, 0],
    "Leadership": [0, 0], "NaturalMagic": [0, 0], "Learning": [0, 0],
    "Training": [0, 0], "DestructiveMagic": [0, 0], "Sorcery": [0, 0],
    "Voice": [0, 0], "Despotism": [0, 0],
    "Innates": [104, 0], "Racial": [180, 0],
}

def at(branch, dx, dy):
    return [coordinates_relative[branch][0] + dx, coordinates_relative[branch][1] + dy]

# Masteries row: y=5, x=45/75/105. Perks row: y=45, x by steps of 25.
# y=0 means the position depends on the variant (see variant_element_y)
coordinates_skills = {
  '001001': at("Logistics", 45, 5),
  '001002': at("Logistics", 75, 5),
  '001003': at("Logistics", 105, 5),
  '002001': at("Warfare", 45, 5),
  '002002': at("Warfare", 75, 5),
  '002003': at("Warfare", 105, 5),
  '003001': at("Learning", 45, 5),
  '003002': at("Learning", 75, 5),
  '003003': at("Learning", 105, 5),
  '004001': at("Racial", 40, 26),
  '004002': at("Racial", 70, 26),
  '004003': at("Racial", 100, 26),
  '004004': at("Racial", 130, 26),
  '005001': at("Leadership", 45, 5),
  '005002': at("Leadership", 75, 5),
  '005003': at("Leadership", 105, 5),
  '006001': at("Offence", 45, 5),
  '006002': at("Offence", 75, 5),
  '006003': at("Offence", 105, 5),
  '007001': at("Defense", 45, 5),
  '007002': at("Defense", 75, 5),
  '007003': at("Defense", 105, 5),
  '008001': at("Sorcery", 45, 5),
  '008002': at("Sorcery", 75, 5),
  '008003': at("Sorcery", 105, 5),
  '009001': at("DestructiveMagic", 45, 5),
  '009002': at("DestructiveMagic", 75, 5),
  '009003': at("DestructiveMagic", 105, 5),
  '010001': at("DarkMagic", 45, 5),
  '010002': at("DarkMagic", 75, 5),
  '010003': at("DarkMagic", 105, 5),
  '011001': at("LightMagic", 45, 5),
  '011002': at("LightMagic", 75, 5),
  '011003': at("LightMagic", 105, 5),
  '012001': at("NaturalMagic", 45, 5),
  '012002': at("NaturalMagic", 75, 5),
  '012003': at("NaturalMagic", 105, 5),
  '013001': at("Combat", 45, 5),
  '013002': at("Combat", 75, 5),
  '013003': at("Combat", 105, 5),
  '014001': at("Racial", 40, 26),
  '014002': at("Racial", 70, 26),
  '014003': at("Racial", 100, 26),
  '014004': at("Racial", 130, 26),
  '015001': at("Racial", 40, 26),
  '015002': at("Racial", 70, 26),
  '015003': at("Racial", 100, 26),
  '015004': at("Racial", 130, 26),
  '016001': at("Racial", 40, 26),
  '016002': at("Racial", 70, 26),
  '016003': at("Racial", 100, 26),
  '016004': at("Racial", 130, 26),
  '017001': at("Racial", 40, 26),
  '017002': at("Racial", 70, 26),
  '017003': at("Racial", 100, 26),
  '017004': at("Racial", 130, 26),
  '018001': at("Racial", 40, 26),
  '018002': at("Racial", 70, 26),
  '018003': at("Racial", 100, 26),
  '018004': at("Racial", 130, 26),
  '019000': at("Logistics", 5, 45),
  '020000': at("Logistics", 30, 45),
  '021000': at("Training", 100, 45),
  '022000': at("Warfare", 100, 45),
  '023000': at("Warfare", 5, 45),
  '025000': at("Learning", 100, 45),
  '026000': at("Learning", 30, 45),
  '027000': at("Learning", 5, 45),
  '028000': at("Logistics", 100, 45),
  '029000': at("Governance", 5, 45),
  '030000': at("Leadership", 5, 45),
  '031000': at("ShatterMagic", 125, 55),
  '032000': at("Training", 125, 45),
  '033000': at("Governance", 30, 45),
  '034000': at("Offence", 30, 45),
  '035000': at("Offence", 100, 45),
  '036000': at("Training", 30, 45),
  '037000': at("ShatterMagic", 5, 45),
  '038000': at("Defense", 100, 45),
  '039000': at("Training", 5, 45),
  '040000': at("Sorcery", 150, 45),
  '041000': at("Sorcery", 100, 45),
  '042000': at("Sorcery", 5, 45),
  '043000': at("DestructiveMagic", 150, 0),
  '044000': at("DestructiveMagic", 150, 0),
  '045000': at("Innates", 240, 26),
  '046000': at("DarkMagic", 5, 45),
  '047000': at("Innates", 60, 26),
  '048000': at("DarkMagic", 100, 45),
  '049000': at("Innates", 90, 26),
  '050000': at("LightMagic", 5, 45),
  '051000': at("LightMagic", 100, 45),
  '052000': at("Innates", 210, 68),
  '053000': at("NaturalMagic", 100, 45),
  '054000': at("Sorcery", 55, 55),
  '055000': [320, 68],
  '056000': [183, 68],
  '057000': [289, 68],
  '058000': at("DarkMagic", 30, 45),
  '059000': [294, 68],
  '060000': at("Combat", 125, 45),
  '061000': at("Leadership", 100, 45),
  '062000': at("Innates", 0, 26),
  '063000': [181, 68],
  '064000': at("Innates", 150, 26),
  '065000': [286, 68],
  '066000': [182, 68],
  '067000': [211, 68],
  '068000': [183, 68],
  '069000': [240, 68],
  '070000': [183, 68],
  '071000': at("Learning", 150, 45),
  '072000': at("Innates", 0, 26),
  '073000': at("Innates", 0, 26),
  '074000': at("Warfare", 55, 45),
  '075000': at("Leadership", 125, 45),
  '076000': at("Innates", 0, 68),
  '077000': at("Defense", 30, 45),
  '078000': [240, 68],
  '079000': at("Innates", 240, 68),
  '080000': at("Governance", 55, 45),
  '081000': at("Innates", 0, 26),
  '082000': [354, 68],
  '083000': at("DarkMagic", 55, 45),
  '084000': at("NaturalMagic", 125, 45),
  '085000': [349, 68],
  '086000': [183, 68],
  '087000': at("Learning", 125, 45),
  '088000': at("Defense", 150, 45),
  '089000': [211, 68],
  '090000': [241, 68],
  '091000': at("Combat", 150, 55),
  '092000': at("Innates", 0, 26),
  '094000': [324, 68],
  '095000': at("Innates", 180, 68),
  '096000': at("Innates", 270, 26),
  '097000': at("Leadership", 30, 45),
  '098000': at("Innates", 0, 68),
  '099000': at("Innates", 90, 68),
  '100000': at("DarkMagic", 150, 45),
  '101000': [243, 68],
  '102000': [357, 68],
  '103000': at("Innates", 0, 68),
  '104000': [0, 0],
  '105000': [295, 68],
  '106000': [327, 68],
  '107000': at("DestructiveMagic", 150, 0),
  '108000': at("DarkMagic", 125, 45),
  '109000': at("Racial", 50, 68),
  '110000': [211, 68],
  '111000': at("Leadership", 55, 45),
  '112000': at("Innates", 0, 26),
  '113000': [211, 68],
  '114000': [315, 68],
  '115000': [347, 68],
  '116000': at("Offence", 150, 45),
  '117000': at("Innates", 0, 68),
  '118000': at("Leadership", 150, 45),
  '119000': at("Racial", 20, 68),
  '120000': [0, 0],
  '121000': at("Innates", 0, 26),
  '122000': at("NaturalMagic", 55, 45),
  '123000': at("NaturalMagic", 30, 45),
  '124000': at("Offence", 125, 45),
  '125000': [320, 68],
  '126000': [349, 68],
  '128000': [289, 68],
  '129000': at("Logistics", 125, 45),
  '130000': at("Warfare", 30, 45),
  '131000': at("Defense", 125, 45),
  '132000': at("LightMagic", 55, 45),
  '133000': at("ShatterMagic", 30, 45),
  '134000': at("Training", 150, 55),
  '135000': at("Training", 150, 35),
  '136000': at("Innates", 0, 26),
  '137000': at("Innates", 0, 68),
  '138000': [352, 68],
  '139000': at("LightMagic", 125, 45),
  '140000': at("Sorcery", 125, 45),
  '141000': at("Offence", 55, 45),
  '142000': [242, 68],
  '143000': [321, 68],
  '144000': [290, 68],
  '145000': [214, 68],
  '146000': at("DestructiveMagic", 5, 45),
  '147000': at("DestructiveMagic", 55, 55),
  '148000': at("Sorcery", 30, 45),
  '149000': [244, 68],
  '150000': at("Innates", 0, 68),
  '151001': at("Racial", 40, 26),
  '151002': at("Racial", 70, 26),
  '151003': at("Racial", 100, 26),
  '151004': at("Racial", 130, 26),
  '152000': [212, 68],
  '153000': [242, 68],
  '154000': [183, 68],
  '155000': at("Sorcery", 55, 35),
  '156000': at("Warfare", 125, 45),
  '157000': [293, 68],
  '158000': [324, 68],
  '159000': at("ShatterMagic", 150, 55),
  '160000': at("Offence", 5, 45),
  '161000': at("Defense", 5, 45),
  '162000': at("Voice", 150, 45),
  '163000': at("DestructiveMagic", 150, 0),
  '164000': at("Innates", 0, 26),
  '165000': at("LightMagic", 150, 45),
  '166000': [352, 68],
  '167000': at("Innates", 0, 68),
  '168000': at("Logistics", 55, 45),
  '169000': at("Learning", 55, 45),
  '170000': [211, 68],
  '171000': at("Defense", 55, 45),
  '172001': at("Racial", 40, 26),
  '172002': at("Racial", 70, 26),
  '172003': at("Racial", 100, 26),
  '172004': at("Racial", 130, 26),
  '173000': at("Voice", 100, 45),
  '174000': [183, 68],
  '175000': at("Combat", 30, 45),
  '176000': at("Innates", 0, 68),
  '177000': at("Logistics", 150, 45),
  '178000': [211, 68],
  '179000': at("Voice", 125, 45),
  '180000': at("Combat", 55, 55),
  '181000': [320, 68],
  '182000': [289, 68],
  '183000': at("Racial", 120, 68),
  '184000': [240, 68],
  '185000': at("Warfare", 150, 45),
  '186000': [349, 68],
  '187001': at("Voice", 45, 5),
  '187002': at("Voice", 75, 5),
  '187003': at("Voice", 105, 5),
  '188000': at("Voice", 30, 45),
  '189000': at("Voice", 5, 45),
  '190000': at("Voice", 55, 45),
  '207000': at("ShatterMagic", 100, 45),
  '210000': at("NaturalMagic", 5, 45),
  '211000': at("DestructiveMagic", 30, 45),
  '212000': at("Despotism", 5, 45),
  '213000': at("Despotism", 30, 45),
  '214000': at("Despotism", 55, 45),
  '215000': at("Innates", 120, 26),
  '216000': at("LightMagic", 30, 45),
  '217000': at("Racial", 150, 68),
  '218000': at("Combat", 55, 35),
  '219000': at("Combat", 150, 35),
  '220000': at("Innates", 210, 26),
  '221000': at("Governance", 100, 45),
  '222000': at("Governance", 125, 45),
  '223000': at("Governance", 150, 45),
  '224000': at("Training", 55, 45),
  '225000': at("Combat", 5, 45),
  '226000': at("Combat", 100, 45),
  '227000': at("ShatterMagic", 55, 45),
  '228000': at("ShatterMagic", 125, 35),
  '229000': at("ShatterMagic", 150, 35),
  '230000': at("DestructiveMagic", 100, 45),
  '231000': at("DestructiveMagic", 125, 0),
  '232000': at("DestructiveMagic", 125, 0),
  '233000': at("DestructiveMagic", 125, 0),
  '234000': at("DestructiveMagic", 125, 0),
  '235000': at("DestructiveMagic", 55, 35),
  '241000': at("NaturalMagic", 150, 0),
  '242000': at("NaturalMagic", 150, 0),
  '243000': at("NaturalMagic", 150, 0),
  '244000': at("NaturalMagic", 150, 0),
  '246000': at("Innates", 150, 68),
  '247000': at("Innates", 120, 68),
  '248000': at("Innates", 180, 26),
  '249001': at("ShatterMagic", 45, 5),
  '249002': at("ShatterMagic", 75, 5),
  '249003': at("ShatterMagic", 105, 5),
  '250001': at("Governance", 45, 5),
  '250002': at("Governance", 75, 5),
  '250003': at("Governance", 105, 5),
  '251001': at("Training", 45, 5),
  '251002': at("Training", 75, 5),
  '251003': at("Training", 105, 5),
  '252001': at("Despotism", 45, 5),
  '252002': at("Despotism", 75, 5),
  '252003': at("Despotism", 105, 5),
  '253001': at("Innates", 131, 26),
  '253002': at("Innates", 161, 26),
  '253003': at("Innates", 191, 26),
}

def element_path(id, branch, *parts):
    return os.path.join(skills_pedia_path, "_Skills", branch, id, *parts)
def description_path(id, *parts):
    return os.path.join(skills_pedia_path, "_Description", id, *parts)
def branch_folders(branch):
    return [f"{branch}_{v}" for v in variants] if branch in variant_branches else [branch]


skill_index = {skill["ID"]: nb for nb, skill in enumerate(skills_data)}

# Tint of the normal icon when an element has no gray texture (0xFF808080)
gray_tint = -8355712

def find_gray_texture(icon_href, gray_href=None):
    """Gray version of an icon: the one given by Skills.xdb (perks), else <icon>_grey.xdb / <icon>_grey.(Texture).xdb in the mod."""
    if gray_href:
        return gray_href
    base = href_path(icon_href)
    base = base[:-len(".(Texture).xdb")] if base.endswith(".(Texture).xdb") else base[:-len(".xdb")]
    for suffix in ("_grey.xdb", "_grey.(Texture).xdb"):
        if game_file(base + suffix):
            return f"/{base}{suffix}#xpointer(/Texture)"
    return None

def get_skill_id_from_name(name):
    if name not in skill_index:
        warn(f"prerequisite skill with name {name} not found")
        return 0
    return skill_index[name]

def find_prerequisites(base_skill, req_id):
    skill = skills_data[req_id]
    if skill["obj"]["SkillType"] == "SKILLTYPE_STANDART_PERK":
        return [f"{base_skill:03}001"]
    if skill["obj"]["SkillType"] == "SKILLTYPE_SPECIAL_PERK":
        req_req = get_skill_id_from_name(skill["obj"]["SkillPrerequisites"]["Item"][0]["dependenciesIDs"]["Item"])
        req = [f"{req_req:03}000"]
        req.append(f"{base_skill:03}001")
        req.append(f"{base_skill:03}002")
        return req


# Elements (skill masteries and perks) and their prerequisites, highlighted when hovering the element
elements = {}
prerequisites = {}

for counter, skill in enumerate(skills_data):
    if skill["obj"]["SkillType"] == "SKILLTYPE_SKILL":
        if not skill["obj"]["NameFileRef"]:
            continue
        ranks = len(skill["obj"]["NameFileRef"]["Item"])
        for k in range(1, ranks+1):
            id = f"{counter:03}{k:03}"
            elements[id] = {
                'skill_id': skill['ID'],
                'icon': skill["obj"]["Texture"]["Item"][k]["@href"],
                'gray': find_gray_texture(skill["obj"]["Texture"]["Item"][k]["@href"]),
                'name': skill["obj"]["NameFileRef"]["Item"][k-1]["@href"],
                'desc': skill["obj"]["DescriptionFileRef"]["Item"][k-1]["@href"],
            }
            # Previous masteries of the same skill
            prerequisites[id] = [f"{counter:03}{r:03}" for r in range(k-1, 0, -1)]
    else:
        id = f"{counter:03}000"
        elements[id] = {
            'skill_id': skill['ID'],
            'icon': skill["obj"]["Texture"]["Item"][1]["@href"],
            'gray': find_gray_texture(skill["obj"]["Texture"]["Item"][1]["@href"], (items(skill["obj"]["Texture"])[0] or {}).get("@href")),
            'name': skill["obj"]["NameFileRef"]["Item"]["@href"],
            'desc': skill["obj"]["DescriptionFileRef"]["Item"]["@href"],
        }
        base_skill = get_skill_id_from_name(skill["obj"]["BasicSkillID"])
        if base_skill == 0 or base_skill == 254:
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


def variant_element_y(id, variant):
    """Row of the 4 elemental perks in each variant of the Destructive and Natural magic branches."""
    rows = {
        'a': {20: ['231000', '241000', '163000'], 40: ['232000', '243000', '107000'], 0: ['233000', '244000', '043000'], 60: ['234000', '242000', '044000']},
        'b': {0: ['231000', '241000', '163000'], 20: ['232000', '243000', '107000'], 60: ['233000', '244000', '043000'], 40: ['234000', '242000', '044000']},
        'c': {20: ['231000', '241000', '163000'], 40: ['232000', '243000', '107000'], 60: ['233000', '244000', '043000'], 0: ['234000', '242000', '044000']},
        'd': {20: ['231000', '241000', '163000'], 0: ['232000', '243000', '107000'], 60: ['233000', '244000', '043000'], 40: ['234000', '242000', '044000']},
    }
    for y, ids in rows.get(variant, {}).items():
        if id in ids:
            return y
    return 45

def process_skill_element(branch, id, element, variant=None):
    """Writes the files of one element, returns False when it is not displayed in this variant."""
    gen.log(f"Processing ID {id} in {branch}...")
    if id not in coordinates_skills:
        warn(f"no coordinates for ID {id} ({element['skill_id']}) in {branch}, add it to coordinates_skills")
        return False
    x, y = coordinates_skills[id]
    if y == 0:
        y = variant_element_y(id, variant)
        if y == 0:
            return False
    icon_size = find_icon_size(element['icon'])
    gen.write("button.(WindowMSButton).xdb.j2", element_path(id, branch, f"{id}.(WindowMSButton).xdb"), {'skill_id': id, 'skill_name': element['skill_id'], 'pos_x': x, 'pos_y': y})
    gen.write("buttonshared.(WindowMSButtonShared).xdb.j2", element_path(id, branch, f"{id}.(WindowMSButtonShared).xdb"), {'branch': branch, 'skill_id': id, 'required_skills': prerequisites[id]})
    gen.write("skillicon.(WindowSimple).xdb.j2", element_path(id, branch, f"{id}_icon.(WindowSimple).xdb"), {'skill_id': id})
    gen.write("skillicon.(WindowSimpleShared).xdb.j2", element_path(id, branch, f"{id}_icon.(WindowSimpleShared).xdb"), {'skill_id': id})
    gen.write("icon.(BackgroundSimpleScallingTexture).xdb.j2", element_path(id, branch, f"{id}.(BackgroundSimpleScallingTexture).xdb"), {'icon_path': element['icon'], 'icon_size': icon_size})
    gen.write("selection.(WindowMSButton).xdb.j2", element_path(id, branch, "highlight", f"{id}_highlight.(WindowMSButton).xdb"), {'skill_id': id, 'variant': variant, 'pos_x': x, 'pos_y': y})
    gen.write("uimessage1.(UISSendUIMessage).xdb.j2", element_path(id, branch, "highlight", f"{id}_on.(UISSendUIMessage).xdb"), {'skill_id': id, 'variant': variant})
    gen.write("uimessage2.(UISSendUIMessage).xdb.j2", element_path(id, branch, "highlight", f"{id}_off.(UISSendUIMessage).xdb"), {'skill_id': id, 'variant': variant})
    gen.write("descuimessage.(UISSendUIMessage).xdb.j2", description_path(id, f"{id}.(UISSendUIMessage).xdb"), {'skill_id': id})
    gen.write("windowbase.(WindowSimple).xdb.j2", description_path(id, f"{id}_window.(WindowSimple).xdb"), {'skill_id': id})
    gen.write("windowshared.(WindowSimpleShared).xdb.j2", description_path(id, f"{id}_window.(WindowSimpleShared).xdb"), {'skill_id': id})
    gen.write("iconbase.(WindowMSButton).xdb.j2", description_path(id, f"{id}_icon.(WindowMSButton).xdb"), {'skill_id': id})
    gen.write("iconshared.(WindowMSButtonShared).xdb.j2", description_path(id, f"{id}_icon.(WindowMSButtonShared).xdb"), {'skill_id': id})
    gen.write("icon.(BackgroundSimpleScallingTexture).xdb.j2", description_path(id, f"{id}_icon.(BackgroundSimpleScallingTexture).xdb"), {'icon_path': element['icon'], 'icon_size': icon_size})
    gen.write("skillname.(WindowTextView).xdb.j2", description_path(id, f"{id}_name.(WindowTextView).xdb"), {'skill_id': id, 'name_path': element['name']})
    gen.write("skilldesc.(WindowTextView).xdb.j2", description_path(id, f"{id}_desc.(WindowTextView).xdb"), {'skill_id': id, 'desc_path': element['desc']})
    # Gray version, displayed when the branch is not available to the hero class: an icon with the name as tooltip
    gen.write("grayicon.(WindowSimple).xdb.j2", element_path(id, branch, "gray", f"{id}_gray.(WindowSimple).xdb"), {'skill_id': id, 'name_path': element['name'], 'pos_x': x + 3, 'pos_y': y + 3})
    gen.write("grayicon.(WindowSimpleShared).xdb.j2", element_path(id, branch, "gray", f"{id}_gray.(WindowSimpleShared).xdb"), {'skill_id': id})
    gen.write("icon.(BackgroundSimpleScallingTexture).xdb.j2", element_path(id, branch, "gray", f"{id}_gray.(BackgroundSimpleScallingTexture).xdb"),
              {'icon_path': element['gray'] or element['icon'], 'icon_size': icon_size, 'color': -1 if element['gray'] else gray_tint})
    if not element['gray']:
        missing_gray.add(id)
    generated_in[branch].add(id)
    return True


# Elements, placed in the branches where their folder exists
generated = set()
generated_in = defaultdict(set)
missing_gray = set()
for id, element in elements.items():
    found_in = []
    for branch in branches:
        variant_list = variants if branch in variant_branches else [None]
        for folder, variant in zip(branch_folders(branch), variant_list):
            if os.path.exists(element_path(id, folder)):
                if found_in and branch not in found_in:
                    warn(f"ID {id} found in both {found_in[0]} and {branch}")
                found_in.append(branch)
                if process_skill_element(folder, id, element, variant):
                    generated.add(id)
    if not found_in:
        if (element['name'] == "") or ('XXX' in element['name']):
            skill_name = element['skill_id']
        else:
            with open(os.path.join(TEXTS_EN, element['name'][1:]), 'r', encoding="utf-16") as skill_name_txt:
                skill_name = skill_name_txt.read().strip()
        warn(f"missing button folder for ID {id} ({skill_name})")

# Branch windows, listing every element folder of the branch
for branch in branches:
    for folder in branch_folders(branch):
        if branch in coordinates_branch and branch != "Innates":
            x, y = coordinates_branch[branch]
            gen.write("branch.(WindowSimple).xdb.j2", os.path.join(skills_pedia_path, "_Skills", folder, f"{folder}.(WindowSimple).xdb"), {'skill_name': folder, 'pos_x': x, 'pos_y': y})
        branch_dir = os.path.join(skills_pedia_path, "_Skills", folder)
        branch_skills = sorted(d for d in os.listdir(branch_dir) if os.path.isdir(os.path.join(branch_dir, d)))
        for id in branch_skills:
            if id not in elements:
                warn(f"folder {folder}/{id} does not match any skill of Skills.xdb")
        gen.write("branch.(WindowSimpleShared).xdb.j2", os.path.join(branch_dir, f"{folder}.(WindowSimpleShared).xdb"),
                  {'skills': branch_skills, 'header': branch_header.get(branch, []), 'extra': branch_extra.get(branch, [])})

# Gray branch windows of the tree (not of Innates and racial branches), in a container of the encyclopedia only
def skills_file(*parts):
    return os.path.join(skills_pedia_path, *parts)
def skills_href(*parts):
    return "/UI/Doc/Skills/" + "/".join(parts)

gray_folders = [folder for branch in branches if branch in coordinates_branch and branch != "Innates" for folder in branch_folders(branch)]
for folder in gray_folders:
    x, y = coordinates_branch[folder.split("_")[0]]
    gen.write("graybranch.(WindowSimple).xdb.j2", skills_file("_Skills", folder, f"{folder}Gray.(WindowSimple).xdb"), {'skill_name': folder, 'pos_x': x, 'pos_y': y})
    gen.write("graybranch.(WindowSimpleShared).xdb.j2", skills_file("_Skills", folder, f"{folder}Gray.(WindowSimpleShared).xdb"), {'skills': sorted(generated_in[folder])})
    for name, shown in (("GrayOn", 1), ("GrayOff", 0)):
        gen.write("message.(UISSendUIMessage).xdb.j2", skills_file("_Skills", folder, f"{name}.(UISSendUIMessage).xdb"),
                  {'message': "UI_SHOW_WINDOW", 'target': f"DocSkillsGray{folder}", 'forward': shown, 'back': 1 - shown})
gen.write("grayroot.(WindowSimple).xdb.j2", skills_file("_Skills", "Gray.(WindowSimple).xdb"), {'priority': 0})
gen.write("grayroot.(WindowSimpleShared).xdb.j2", skills_file("_Skills", "Gray.(WindowSimpleShared).xdb"), {'folders': gray_folders})


# Class views of each faction: the branches of the hero class are shown, the other branches of the tree are grayed out
# Encyclopedia folder, number of its buttons, hero class prefix, variant of the Destructive and Natural magic branches
factions = [
    ("Haven", 1, "HAVEN", "a"), ("Inferno", 2, "INFERNO", "d"), ("Necro", 3, "NECROPOLIS", "b"), ("Preserve", 4, "PRESERVE", "b"),
    ("Dungeon", 5, "DUNGEON", "c"), ("Academy", 6, "ACADEMY", "c"), ("Fortress", 7, "FORTRESS", "a"), ("Stronghold", 8, "STRONGHOLD", "d"),
]
# Faction textures in /UI/Doc/Common, when not named after the folder
faction_textures = {"Necro": "Necropolis"}
# View buttons and their x position; the first one is the view selected with the faction
class_kinds = {"Might": 575, "Magic": 635}
# Slots of the tree: branches sharing a position, the first one is grayed out when no class of the faction has any of them
tree_slots = [["Logistics"], ["ShatterMagic"], ["Combat"], ["Warfare"], ["LightMagic"], ["Offence"], ["Governance"], ["DarkMagic"],
              ["Defense"], ["Leadership"], ["NaturalMagic"], ["Learning"], ["Training", "Despotism"], ["DestructiveMagic"], ["Sorcery", "Voice"]]
assert sorted(b for slot in tree_slots for b in slot) == sorted(b for b in branches if b in coordinates_branch and b != "Innates")

hero_classes = {item["ID"]: item["obj"] for item in as_list(load_xdb(GAME_DATA, "heroes", "GameMechanics", "RefTables", "HeroClass.xdb")["Table_HeroClassDesc_HeroClass"]["objects"]["Item"])}
def class_skills(hero_class):
    return {skill["SkillID"] for skill in items(hero_class["SkillsProbs"]) if int(skill["Prob"]) > 0}
# Skill of each branch, from its first mastery
branch_skill = {branch: elements[id]['skill_id'] for branch in branches for folder in branch_folders(branch) for id in generated_in[folder] if id.endswith("001")}

# Build layout (prototype, for the factions of build_factions), replacing the trees of the faction:
# - a bar on the left lists the hero build, one row per skill of the class: the mastery, then 3 perk slots;
# - the center shows the basic skill icons of the class, clicking one shows its tree in the panel below;
# - clicking an element of the tree adds it to the build with all its requirements,
#   clicking an element of the bar removes it with all the elements that require it.
# Every perk has a fixed slot: each skill has 2 chains of perks, and a chain can only be taken from its start,
# so the first chain fills the slots from the left and the second one from the right.
build_factions = ["Haven"]
build_area = [80, 130, 565, 720]           # x, y, width, height of the layout in the skills window
bar_box = [0, 0, 250, 720]                 # boxes inside the layout
central_box = [260, 0, 305, 300]
tree_box = [260, 310, 305, 410]
tree_size, central_size, slot_size, icon_inset = 48, 56, 48, 4
bar_row_step, bar_col_step, bar_margin = 54, 56, (13, 10)
central_step, central_columns, central_margin = 72, 4, 12
tree_mastery_step, tree_perk_step, tree_row_y, tree_info_y = 56, 52, [15, 95, 175, 255], 335
panel_background = "/UI/Doc/Skills/_Description/DescriptionBack.(BackgroundSimpleScallingTexture).xdb#xpointer(/BackgroundSimpleScallingTexture)"
selected_frame = "/UI/Doc/Skills/Common/Highlight.(BackgroundSimpleScallingTexture).xdb#xpointer(/BackgroundSimpleScallingTexture)"

def build_file(faction, *parts):
    return skills_file(faction, "Build", *parts)
def build_href(faction, *parts):
    return skills_href(faction, "Build", *parts)
def window_href(faction, *parts):
    return build_href(faction, *parts[:-1], f"{parts[-1]}.(WindowSimple).xdb") + "#xpointer(/WindowSimple)"
def button_href(faction, *parts):
    return build_href(faction, *parts[:-1], f"{parts[-1]}.(WindowMSButton).xdb") + "#xpointer(/WindowMSButton)"

def toggle_messages(faction, parts, target, message="UI_SHOW_WINDOW"):
    """Writes the 2 messages showing/hiding (or enabling/disabling) a window, returns their hrefs (on, off)."""
    names = ("Show", "Hide") if message == "UI_SHOW_WINDOW" else ("Enable", "Disable")
    hrefs = []
    for name, value in zip(names, (1, 0)):
        file = f"{parts[-1]}{name}.(UISSendUIMessage).xdb"
        gen.write("message.(UISSendUIMessage).xdb.j2", build_file(faction, *parts[:-1], file), {'message': message, 'target': target, 'forward': value, 'back': 1 - value})
        hrefs.append(build_href(faction, *parts[:-1], file))
    return hrefs

def write_panel(faction, parts, name, box, children, background=None, visible='true'):
    gen.write("panel.(WindowSimple).xdb.j2", build_file(faction, *parts[:-1], f"{parts[-1]}.(WindowSimple).xdb"),
              {'shared': build_href(faction, *parts[:-1], f"{parts[-1]}.(WindowSimpleShared).xdb"), 'name': name, 'visible': visible,
               'pos_x': box[0], 'pos_y': box[1], 'width': box[2], 'height': box[3]})
    gen.write("panel.(WindowSimpleShared).xdb.j2", build_file(faction, *parts[:-1], f"{parts[-1]}.(WindowSimpleShared).xdb"),
              {'children': children, 'background': background})
    return window_href(faction, *parts)

def write_click_button(faction, parts, name, pos, size, icon_shared, commands, hover_commands, disabled_frame=None, tooltip='', priority=1, visible='true'):
    """A button drawing an icon, running commands on click and reversible commands on hover."""
    folder, base = parts[:-1], parts[-1]
    gen.write("iconwindow.(WindowSimple).xdb.j2", build_file(faction, *folder, f"{base}Icon.(WindowSimple).xdb"),
              {'shared': icon_shared, 'name': f"{name}Icon", 'pos_x': icon_inset, 'pos_y': icon_inset, 'size': size - 2 * icon_inset})
    gen.write("clickbutton.(WindowMSButtonShared).xdb.j2", build_file(faction, *folder, f"{base}.(WindowMSButtonShared).xdb"),
              {'icon': build_href(faction, *folder, f"{base}Icon.(WindowSimple).xdb"), 'hover_commands': hover_commands, 'disabled_frame': disabled_frame})
    gen.write("clickbutton.(WindowMSButton).xdb.j2", build_file(faction, *folder, f"{base}.(WindowMSButton).xdb"),
              {'shared': build_href(faction, *folder, f"{base}.(WindowMSButtonShared).xdb"), 'name': name, 'tooltip': tooltip, 'priority': priority,
               'visible': visible, 'pos_x': pos[0], 'pos_y': pos[1], 'size': size, 'commands': commands})
    return button_href(faction, *parts)

def icon_shared_href(folder, id, gray=False):
    if gray:
        return skills_href("_Skills", folder, id, "gray", f"{id}_gray.(WindowSimpleShared).xdb")
    return skills_href("_Skills", folder, id, f"{id}_icon.(WindowSimpleShared).xdb")

def description_href(id):
    return skills_href("_Description", id, f"{id}.(UISSendUIMessage).xdb")

def skill_tree(folder):
    """Masteries, the 2 perk chains as {depth: [perks]} and the information perks (no mastery required) of a branch folder."""
    ids = generated_in[folder]
    masteries = sorted(i for i in ids if not i.endswith("000"))
    perks = sorted(i for i in ids if i.endswith("000"))
    infos = sorted((p for p in perks if not any(r in masteries for r in prerequisites[p])), key=lambda p: (coordinates_skills[p], p))
    pickable = [p for p in perks if p not in infos]
    depth = {}
    def get_depth(p):
        if p not in depth:
            depth[p] = 1 + max([get_depth(r) for r in prerequisites[p] if r in pickable] or [0])
        return depth[p]
    roots = sorted((p for p in pickable if get_depth(p) == 1), key=lambda p: (coordinates_skills[p], p))
    chains = []
    for root in roots:
        chain = defaultdict(list)
        for p in sorted(pickable, key=lambda p: (coordinates_skills[p], p)):
            if p == root or root in requirements(p, pickable):
                chain[get_depth(p)].append(p)
        chains.append(chain)
    if len(chains) != 2 or sum(len(v) for c in chains for v in c.values()) != len(pickable):
        warn(f"{folder} perks are not 2 separate chains, the build slots may overlap")
    return masteries, chains, infos

def requirements(id, members):
    """Every element of members required by id, directly or not."""
    required, stack = set(), [id]
    while stack:
        for r in prerequisites[stack.pop()]:
            if r in members and r not in required:
                required.add(r)
                stack.append(r)
    return required

def assign_columns(chains, max_perks=3):
    """Column (1-3) of each perk in the bar: the first chain from the left, the second from the right, then adjusted so that
    the builds allowed by the game (at most 3 perks, with their requirements) put as few perks as possible in the same column."""
    preferred = {p: depth if side == 0 else 4 - depth for side, chain in enumerate(chains[:2]) for depth, perks in chain.items() for p in perks}
    perks = sorted(preferred, key=lambda p: (preferred[p], p))
    builds, frontier = set(), {frozenset()}
    while frontier:
        new_builds = {b | {p} for b in frontier for p in perks if p not in b and len(b) < max_perks and requirements(p, perks) <= b}
        frontier = new_builds - builds
        builds |= frontier
    builds = [b for b in builds if len(b) > 1]
    best = [None, len(builds) + 1]
    def cost(columns):
        return sum(1 for b in builds if all(p in columns for p in b) and len({columns[p] for p in b}) < len(b))
    def search(i, columns):
        current = cost(columns)
        if current >= best[1]:
            return
        if i == len(perks):
            best[:] = [dict(columns), current]
            return
        p = perks[i]
        for column in sorted((1, 2, 3), key=lambda c: c != preferred[p]):
            columns[p] = column
            search(i + 1, columns)
            del columns[p]
    search(0, {})
    if best[1]:
        gen.log(f"  {best[1]} builds of {len(builds)} put 2 perks in the same column")
    return best[0]

def generate_build(faction, prefix, variant, kind):
    """Writes the build layout of a class, returns the href of its container window."""
    own = class_skills(hero_classes[f"HERO_CLASS_{prefix}_{kind.upper()}"])
    skill_branches = [b for b in racial_branches if branch_skill[b] in own] + [b for slot in tree_slots for b in slot if branch_skill[b] in own]
    folders = {b: f"{b}_{variant}" if b in variant_branches else b for b in skill_branches}
    trees = {b: skill_tree(folders[b]) for b in skill_branches}
    members = {e for b in skill_branches for e in trees[b][0] + [p for chain in trees[b][1] for ps in chain.values() for p in ps]}
    names = lambda what, id: f"DocBuild{faction}{kind}{what}{id}"
    msg = {}
    for b in skill_branches:
        for e in sorted(generated_in[folders[b]]):
            msg[e] = {
                'btn': toggle_messages(faction, [kind, b, e, "Btn"], names("Btn", e), "UI_ENABLE_WINDOW"),
                'slot': toggle_messages(faction, [kind, b, e, "Slot"], names("Slot", e)) if e in members else None,
                # Disabling a highlight shows it, like the selections of the trees
                'hl': toggle_messages(faction, [kind, b, e, "Hl"], names("Hl", e), "UI_ENABLE_WINDOW")[1],
            }
    def pick(e):
        return [m for x in sorted(requirements(e, members) | {e}) for m in (msg[x]['btn'][1], msg[x]['slot'][0])]
    def remove(e):
        return [m for x in sorted({d for d in members if e in requirements(d, members)} | {e}) for m in (msg[x]['btn'][0], msg[x]['slot'][1])]

    bar_children, central_children, tree_children, tree_messages, skill_messages = [], [], [], {}, {}
    for b in skill_branches:
        tree_messages[b] = toggle_messages(faction, [kind, b, "Tree"], names("Tree", b))
        skill_messages[b] = toggle_messages(faction, [kind, b, "Skill"], names("Skill", b), "UI_ENABLE_WINDOW")
    for row, b in enumerate(skill_branches):
        folder = folders[b]
        masteries, chains, infos = trees[b]
        basic = masteries[0]
        # Tree: masteries on top, the 2 chains below (left and right halves), the information perks at the bottom
        positions = {}
        left = (tree_box[2] - (len(masteries) * tree_mastery_step - (tree_mastery_step - tree_size))) // 2
        for i, e in enumerate(masteries):
            positions[e] = (left + i * tree_mastery_step, tree_row_y[0])
        half = tree_box[2] // 2
        for side, chain in enumerate(chains[:2]):
            for depth, perks in chain.items():
                left = side * half + (half - (len(perks) * tree_perk_step - (tree_perk_step - tree_size))) // 2
                for i, p in enumerate(perks):
                    positions[p] = (left + i * tree_perk_step, tree_row_y[min(depth, 3)])
        left = (tree_box[2] - (len(infos) * tree_perk_step - (tree_perk_step - tree_size))) // 2
        for i, p in enumerate(infos):
            positions[p] = (left + i * tree_perk_step, tree_info_y)
        children = []
        for e, pos in positions.items():
            gen.write("highlight.(WindowMSButton).xdb.j2", build_file(faction, kind, b, e, "Hl.(WindowMSButton).xdb"), {'name': names("Hl", e), 'pos_x': pos[0], 'pos_y': pos[1], 'size': tree_size})
            children.append(button_href(faction, kind, b, e, "Hl"))
            highlights = [msg[r]['hl'] for r in sorted(requirements(e, members))] + [msg[e]['hl']]
            children.append(write_click_button(faction, [kind, b, e, "Btn"], names("Btn", e), pos, tree_size, icon_shared_href(folder, e),
                                               pick(e) if e in members else [], highlights + [description_href(e)], selected_frame))
        tree_children.append(write_panel(faction, [kind, b, "Tree"], names("Tree", b), [0, 0, tree_box[2], tree_box[3]], children, visible='false'))

        # Center: the basic skill, showing its tree and selected while it is shown
        others = [x for x in skill_branches if x != b]
        commands = [tree_messages[b][0]] + [tree_messages[x][1] for x in others] + [skill_messages[b][1]] + [skill_messages[x][0] for x in others]
        pos = (central_margin + (row % central_columns) * central_step, central_margin + (row // central_columns) * central_step)
        central_children.append(write_click_button(faction, [kind, b, "Skill"], names("Skill", b), pos, central_size, icon_shared_href(folder, basic),
                                                   commands, [description_href(basic)], selected_frame, tooltip=elements[basic]['name']))

        # Bar row: the grayed basic skill below the slots, then a slot per element, the higher masteries on top
        y = bar_margin[1] + row * bar_row_step
        slot_x = lambda column: bar_margin[0] + column * bar_col_step
        gen.write("iconwindow.(WindowSimple).xdb.j2", build_file(faction, kind, b, "Row.(WindowSimple).xdb"),
                  {'shared': icon_shared_href(folder, basic, gray=True), 'name': names("Row", b), 'tooltip': elements[basic]['name'], 'priority': 0,
                   'pos_x': slot_x(0) + icon_inset, 'pos_y': y + icon_inset, 'size': slot_size - 2 * icon_inset})
        bar_children.append(window_href(faction, kind, b, "Row"))
        slots = [(e, 0, 10 + rank) for rank, e in enumerate(masteries, 1)]
        slots += [(p, column, 11) for p, column in assign_columns(chains).items()]
        for e, column, priority in slots:
            bar_children.append(write_click_button(faction, [kind, b, e, "Slot"], names("Slot", e), (slot_x(min(column, 3)), y), slot_size, icon_shared_href(folder, e),
                                                   remove(e), [description_href(e)], priority=priority, visible='false'))

    children = [write_panel(faction, [kind, "Bar"], names("Bar", ""), bar_box, bar_children, panel_background),
                write_panel(faction, [kind, "Central"], names("Central", ""), central_box, central_children, panel_background),
                write_panel(faction, [kind, "Trees"], names("Trees", ""), tree_box, tree_children, panel_background)]
    return write_panel(faction, [kind, kind], f"DocBuild{faction}{kind}", [0, 0, build_area[2], build_area[3]], children, visible='false')

build_visibility = {}
for faction, number, prefix, variant in factions:
    if faction in build_factions:
        build_visibility[faction] = toggle_messages(faction, ["Build"], f"DocBuild{faction}")
        for kind in class_kinds:
            build_visibility[(faction, kind)] = toggle_messages(faction, [kind, kind], f"DocBuild{faction}{kind}")
        write_panel(faction, ["Build"], f"DocBuild{faction}", build_area, [generate_build(faction, prefix, variant, kind) for kind in class_kinds], visible='false')
    if os.path.isdir(skills_file(faction, "Build")):
        gen.prune_unwritten(skills_file(faction, "Build"))


def view_commands(faction, prefix, variant, kind):
    other_kind = next(k for k in class_kinds if k != kind)
    own = class_skills(hero_classes[f"HERO_CLASS_{prefix}_{kind.upper()}"])
    other = class_skills(hero_classes[f"HERO_CLASS_{prefix}_{other_kind.upper()}"])
    commands = []
    if faction in build_factions:
        commands += [skills_href("_Skills", folder, f"{name}.(UISSendUIMessage).xdb") for slot in tree_slots for branch in slot for folder in branch_folders(branch) for name in ("SwitchOff", "GrayOff")]
        commands += [build_visibility[faction][0], build_visibility[(faction, kind)][0], build_visibility[(faction, other_kind)][1]]
        commands += [skills_href(faction, f"{k}{'Disable' if k == kind else 'Enable'}.(UISSendUIMessage).xdb") for k in class_kinds]
        return commands
    commands += [build_visibility[f][1] for f in build_factions]
    for slot in tree_slots:
        shown = next((b for b in slot if branch_skill[b] in own), None)
        grayed = None if shown else next((b for b in slot if branch_skill[b] in other), slot[0])
        for branch in slot:
            for folder in branch_folders(branch):
                faction_folder = folder in (branch, f"{branch}_{variant}")
                commands.append(skills_href("_Skills", folder, f"Switch{'On' if faction_folder and branch == shown else 'Off'}.(UISSendUIMessage).xdb"))
                commands.append(skills_href("_Skills", folder, f"Gray{'On' if faction_folder and branch == grayed else 'Off'}.(UISSendUIMessage).xdb"))
    # Racial branches that depend on the class (Stronghold), the others are always shown in the faction window
    for branch in racial_branches:
        if (branch_skill[branch] in own) != (branch_skill[branch] in other):
            commands.append(skills_href("_Skills", branch, f"Switch{'On' if branch_skill[branch] in own else 'Off'}.(UISSendUIMessage).xdb"))
    # The selected view button is disabled, which shows it highlighted
    commands += [skills_href(faction, f"{k}{'Disable' if k == kind else 'Enable'}.(UISSendUIMessage).xdb") for k in class_kinds]
    return commands

for faction, number, prefix, variant in factions:
    for kind, pos_x in class_kinds.items():
        gen.write("classbutton.(WindowMSButton).xdb.j2", skills_file(faction, f"{kind}Button.(WindowMSButton).xdb"),
                  {'kind': kind, 'number': number, 'pos_x': pos_x, 'commands': view_commands(faction, prefix, variant, kind)})
        gen.write("classbutton.(WindowMSButtonShared).xdb.j2", skills_file(faction, f"{kind}Button.(WindowMSButtonShared).xdb"), {'kind': kind})
        for name, enabled in (("Enable", 1), ("Disable", 0)):
            gen.write("message.(UISSendUIMessage).xdb.j2", skills_file(faction, f"{kind}{name}.(UISSendUIMessage).xdb"),
                      {'message': "UI_ENABLE_WINDOW", 'target': f"{kind}Button{number}", 'forward': enabled, 'back': 1 - enabled})
    # Selecting the faction lands on its first view
    gen.write("factionbutton.(WindowMSButtonShared).xdb.j2", skills_file(f"{faction}Button", "Button.(WindowMSButtonShared).xdb"),
              {'faction': faction_textures.get(faction, faction), 'commands': view_commands(faction, prefix, variant, next(iter(class_kinds)))})
    for old_file in ("MMButton.(WindowMSButton).xdb", "MMButton.(WindowMSButtonShared).xdb"):
        if os.path.exists(skills_file(faction, old_file)):
            gen.prune(skills_file(faction, old_file))

if missing_gray:
    warn(f"{len(missing_gray)} elements have no gray texture and use their tinted icon (add <icon>_grey.(Texture).xdb, see --debug)")
    for id in sorted(missing_gray):
        gen.log(f"  {id} {elements[id]['skill_id']}: {elements[id]['icon'].split('#')[0]}")

# Description windows: list the generated ones, remove those of elements that are no longer displayed
descriptions_dir = os.path.join(skills_pedia_path, "_Description")
gen.write("desclist.(WindowSimpleShared).xdb.j2", os.path.join(descriptions_dir, "000000.(WindowSimpleShared).xdb"), {'skills': sorted(generated)})
for folder in sorted(os.listdir(descriptions_dir)):
    if re.fullmatch(r"\d{6}", folder) and folder not in generated:
        gen.prune(os.path.join(descriptions_dir, folder))

print(f"Done: {len(generated)} elements, {gen.written} files {'rendered (dry run)' if gen.dry_run else 'written'}")
