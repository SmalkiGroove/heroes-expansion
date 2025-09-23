import os
import xmltodict

workdir = os.path.dirname(os.path.abspath(__file__))
townbuildstats_path = os.path.join(workdir, "../game_data/data/GameMechanics/TownBuildingSharedStats")

towns = ["Haven", "Inferno", "Necromancy", "Preserve", "Dungeon", "Academy", "Dwarves", "Stronghold"]
resources = {"Wood":0, "Ore":0, "Mercury":0, "Crystal":0, "Sulfur":0, "Gem":0, "Gold":0}
town_res = {}

def get_building_cost(building):
    for res in town_res.keys():
        town_res[res] += int(building["Cost"][res])

for town in towns:
    town_res = resources.copy()
    for path, subdirs, files in os.walk(os.path.join(workdir, townbuildstats_path, town)):
        for file in files:
            if file.endswith('.xdb'):
                with open(os.path.join(path, file), 'r') as f:
                    building_data = xmltodict.parse(f.read())
                if "TownBuildingSharedStats" in building_data:
                    building = building_data["TownBuildingSharedStats"]
                    get_building_cost(building)
    print(town, town_res)
