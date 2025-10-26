import os
import xmltodict

workdir = os.path.dirname(os.path.abspath(__file__))
creaturestats_path = os.path.join(workdir, "../game_data/data/GameMechanics/Creature/Creatures")

towns = ["Haven", "Inferno", "Necropolis", "Preserve", "Dungeon", "Academy", "Dwarf", "Orcs", "Neutrals"]
mapping = {
    "HP":"Health", 
    "Att":"AttackSkill", 
    "Def":"DefenceSkill", 
    "MinD":"MinDamage", 
    "MaxD":"MaxDamage", 
    "Speed":"Speed", 
    "Init":"Initiative", 
    "Exp":"Exp", 
    "Power":"Power", 
    "Growth":"WeeklyGrowth"
}

stats = ["Power"]
xtier = 1

def get_creature_stats(creature):
    cr = {}
    for stat in stats:
        key = mapping[stat]
        cr[stat] = int(creature[key])
    return cr

def get_creature_score(creature):
    score = 0
    score += 2 * int(creature["Health"])
    score += 3 * int(creature["AttackSkill"])
    score += 3 * int(creature["DefenceSkill"])
    score += int(creature["MinDamage"])
    score += int(creature["MaxDamage"])
    score += 4 * int(creature["Speed"])
    score += 3 * int(creature["Initiative"])
    score += 2 * int(creature["SpellPoints"])
    if creature["Flying"] == "true":
        score += 10
    if int(creature["Range"]) != 0:
        score += 20
    return score

if xtier == 0:
    mintier = 1
    maxtier = 8
else:
    mintier = xtier
    maxtier = xtier + 1
for tier in range(mintier, maxtier):
    print(f"=== Tier {tier} ===")
    for town in towns:
        for path, subdirs, files in os.walk(os.path.join(workdir, creaturestats_path, town)):
            for file in files:
                if file.endswith('.xdb'):
                    with open(os.path.join(path, file), 'r') as f:
                        creature_data = xmltodict.parse(f.read())
                    if "Creature" in creature_data:
                        creature_data = creature_data["Creature"]
                        if int(creature_data["CreatureTier"]) == tier:
                            creature = get_creature_stats(creature_data)
                            score = get_creature_score(creature_data)
                            print(file, creature, score)
