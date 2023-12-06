import os
import re
import yaml
import xmltodict

# MARKDOWN TEXT GENERATOR FOR README
# USAGE : python doc.py ...

workdir = os.path.dirname(os.path.abspath(__file__))
reference_file = os.path.join(workdir, "doc-refs.yml")
doc_path = "../doc"

### CREATURES
###############################################################################################################################################################
#
path_to_creatures = "../game_data/data/GameMechanics/Creature/Creatures"

def creature_doc_line(tier, upg, name, path):
    with open(path, 'r') as xdb:
        creature = xmltodict.parse(xdb.read())
    growth = creature['Creature']['WeeklyGrowth']
    hp = creature['Creature']['Health']
    atk = creature['Creature']['AttackSkill']
    dfs = creature['Creature']['DefenceSkill']
    dmg = f"{creature['Creature']['MinDamage']}-{creature['Creature']['MaxDamage']}"
    spd = creature['Creature']['Speed']
    init = creature['Creature']['Initiative']
    if creature['Creature']['KnownSpells']:
        spells = "WIP" #creature['Creature']['KnownSpells']['Item']
    else:
        spells = "_none_"
    if creature['Creature']['Abilities']:
        if isinstance(creature['Creature']['Abilities']['Item'], list):
            abilities = ', '.join(creature['Creature']['Abilities']['Item']).replace("ABILITY_","")
        else:
            abilities = creature['Creature']['Abilities']['Item'].replace("ABILITY_","")
    else:
        abilities = '_none_'
    return f"| {name} | {tier} | {growth} | {hp} | {atk} | {dfs} | {dmg} | {spd} | {init} | {spells} | {abilities} |"

def generate_creature_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'CREATURES.md'), 'w')
    print("# CREATURES DOCUMENTATION", file=out)
    for faction in ref_data.keys():
        print("", file=out)
        print(f"### {faction}:", file=out)
        print("| CREATURE | TIER | NB | HP | ATT | DEF | DMG± | SPD | INIT | SPELLS | ABILITIES |", file=out)
        print("|----------|------|----|----|-----|-----|------|-----|------|--------|-----------|", file=out)
        for c in ref_data[faction]:
            name = c['name']
            tier = c['tier']
            upg = c['upgrade']
            path = os.path.join(workdir, path_to_creatures, c['path'])
            line = creature_doc_line(tier, upg, name, path)
            print(line, file=out)
    out.close()
#
###############################################################################################################################################################

### HEROES
###############################################################################################################################################################
#
path_to_heroes = "../game_data/data/MapObjects"
path_to_texts = "../game_data/texts"

def hero_doc_line(name, path):
    with open(path, 'r') as xdb:
        hero = xmltodict.parse(xdb.read())
    desc_path = os.path.join(workdir, path_to_texts + hero['AdvMapHeroShared']['SpecializationNameFileRef']['@href'])
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
    return re.sub(r'<[^>]+>', '', desc)

def generate_heroes_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'HEROES.md'), 'w')
    print("# HEROES DOCUMENTATION", file=out)
    for faction in ref_data.keys():
        print("", file=out)
        print(f"### {faction}:", file=out)
        for h in ref_data[faction]:
            name = h['name']
            path = os.path.join(workdir, path_to_heroes, h['path'])
            hero = hero_doc_line(name, path)
            print("", file=out)
            print("---", file=out)
            print(f"__{name} :__", file=out)
            print(hero, file=out)
    out.close()
#
###############################################################################################################################################################

### SKILLS
###############################################################################################################################################################
#
path_to_skills = "../game_data/data/GameMechanics/RefTables/Skills.xdb"

def skill_doc_line(skill):
    name_path = os.path.join(workdir, path_to_texts + skill['obj']['NameFileRef']['Item']['@href'])
    desc_path = os.path.join(workdir, path_to_texts + skill['obj']['DescriptionFileRef']['Item']['@href'])
    with open(name_path, 'r', encoding='utf-16') as name_file:
        name = name_file.read()
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
    return f"- __{name}__ : {desc}"

def get_skill_by_id(skills, id):
    id = 'HERO_SKILL_' + id
    for item in skills:
        if item['ID'] == id:
            return item
    print(f"Skill '{id}' not found")
    return None

def generate_skills_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'SKILLS.md'), 'w')
    print("# SKILLS DOCUMENTATION", file=out)
    file_path = os.path.join(workdir, path_to_skills)
    with open(file_path, 'r') as xdb:
        skills = xmltodict.parse(xdb.read())['Table_HeroSkill_SkillID']['objects']['Item']
    for s in ref_data.keys():
        base = get_skill_by_id(skills, s)
        if base != None:
            print("", file=out)
            print(f"### {s}", file=out)
            for p in ref_data[s]['perks']:
                perk = get_skill_by_id(skills, p)
                if perk != None:
                    print(skill_doc_line(perk), file=out)
    out.close()
#
###############################################################################################################################################################


with open(reference_file) as ref:
    data = yaml.safe_load(ref)

# generate_creature_doc(data['CREATURES'])
# generate_heroes_doc(data['HEROES'])
generate_skills_doc(data['SKILLS'])
