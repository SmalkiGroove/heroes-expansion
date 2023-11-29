import os
import yaml
import xmltodict

# MARKDOWN TEXT GENERATOR FOR README
# USAGE : python doc.py ...

workdir = os.path.dirname(os.path.abspath(__file__))
reference_file = os.path.join(workdir, "doc-refs.yml")

path_to_creatures = "../game_data/data/GameMechanics/Creature/Creatures"


def creature_doc_header(faction):
    print("")
    print(f"__{faction}:__")
    print("| CREATURE | TIER | NB | HP | ATT | DEF | DMG | SPD | INIT | SPELLS | ABILITIES |")
    print("|----------|------|----|----|-----|-----|-----|-----|------|--------|-----------|")

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
            abilities = ','.join(creature['Creature']['Abilities']['Item'])
        else:
            abilities = creature['Creature']['Abilities']['Item']
    else:
        abilities = '_none_'
    print(f"| {name} | {tier} | {growth} | {hp} | {atk} | {dfs} | {dmg} | {spd} | {init} | {spells} | {abilities} |")



with open(reference_file) as ref:
    data = yaml.safe_load(ref)

for faction in data['CREATURES'].keys():
    creature_doc_header(faction)
    for c in data['CREATURES'][faction]:
        name = c['name']
        tier = c['tier']
        upg = c['upgrade']
        path = os.path.join(workdir, path_to_creatures, c['path'])
        creature_doc_line(tier, upg, name, path)
