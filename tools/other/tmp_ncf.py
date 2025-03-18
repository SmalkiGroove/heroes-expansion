import os

creatures_path = "../../game_data/data/GameMechanics/Creature/Creatures/"

with open(os.path.join(creatures_path, "_NCF/Creature_180.xdb"), 'r') as example_file:
    example = example_file.read()

for i in range(181,999):
    with open(os.path.join(creatures_path, f"_NCF/Creature_{i}.xdb"), 'w') as new_file:
        new_file.write(example)
