import os
import yaml
import xmltodict

# MARKDOWN TEXT GENERATOR FOR README
# USAGE : python doc.py ...

workdir = os.path.dirname(os.path.abspath(__file__))
reference_file = os.path.join(workdir, "doc-refs.yml")
doc_path = "../doc"

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
            abilities = ','.join(creature['Creature']['Abilities']['Item']).replace("ABILITY_","")
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
        print(f"__{faction}:__", file=out)
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



with open(reference_file) as ref:
    data = yaml.safe_load(ref)

generate_creature_doc(data['CREATURES'])