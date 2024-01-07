import sys

factions = {
    "ALL": -1,
    "HAVEN": 0,
    "PRESERVE": 1,
    "FORTRESS": 2,
    "ACADEMY": 3,
    "DUNGEON": 4,
    "NECROPOLIS": 5,
    "INFERNO": 6,
    "STRONGHOLD": 7,
}
classes = [
    "HERO_CLASS_HAVEN_MIGHT",
    "HERO_CLASS_HAVEN_MAGIC",
    "HERO_CLASS_PRESERVE_MIGHT",
    "HERO_CLASS_PRESERVE_MAGIC",
    "HERO_CLASS_FORTRESS_MIGHT",
    "HERO_CLASS_FORTRESS_MAGIC",
    "HERO_CLASS_ACADEMY_MIGHT",
    "HERO_CLASS_ACADEMY_MAGIC",
    "HERO_CLASS_DUNGEON_MIGHT",
    "HERO_CLASS_DUNGEON_MAGIC",
    "HERO_CLASS_NECROPOLIS_MIGHT",
    "HERO_CLASS_NECROPOLIS_MAGIC",
    "HERO_CLASS_INFERNO_MIGHT",
    "HERO_CLASS_INFERNO_MAGIC",
    "HERO_CLASS_STRONGHOLD_MIGHT",
    "HERO_CLASS_STRONGHOLD_MAGIC",
]

if len(sys.argv) != 3:
    print("Script requires 1 arguments. Example: 'skill-requirement.py all HERO_SKILL_INTUITION'.")
    sys.exit(1)
else:
    faction = sys.argv[1].upper()
    if not faction in factions:
        print(f"Argument 1 should be a faction name. Got '{faction}'.")
        sys.exit(1)
    req = sys.argv[2]
    if not "HERO_SKILL_" in req:
        print(f"Argument 2 should be a hero skill ID. Got '{req}'.")
        sys.exit(1)

if faction == "ALL":
    for cls in classes:
        print(f"<Item><Class>{cls}</Class><dependenciesIDs><Item>{req}</Item></dependenciesIDs></Item>")
else:
    index = factions[faction]
    print(f"<Item><Class>{classes[2*index]}</Class><dependenciesIDs><Item>{req}</Item></dependenciesIDs></Item>")
    print(f"<Item><Class>{classes[2*index+1]}</Class><dependenciesIDs><Item>{req}</Item></dependenciesIDs></Item>")