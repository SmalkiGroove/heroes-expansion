import os
import xmltodict

workdir = os.path.dirname(os.path.abspath(__file__))
townbuildstats_path = os.path.join(workdir, "../../game_data/towns/GameMechanics/TownBuildingSharedStats")

towns = ["Haven", "Inferno", "Necromancy", "Preserve", "Dungeon", "Academy", "Dwarves", "Stronghold"]
resources = ["Wood", "Ore", "Mercury", "Crystal", "Sulfur", "Gem", "Gold"]

def get_town_cost(town):
    town_res = dict.fromkeys(resources, 0)
    for path, subdirs, files in os.walk(os.path.join(townbuildstats_path, town)):
        for file in files:
            if file.endswith('.xdb'):
                with open(os.path.join(path, file), 'r') as f:
                    building_data = xmltodict.parse(f.read())
                if "TownBuildingSharedStats" in building_data:
                    building = building_data["TownBuildingSharedStats"]
                    for res in resources:
                        town_res[res] += int(building["Cost"][res])
    return town_res

for town in towns:
    print(town, get_town_cost(town))
