"""Generates the Heroes tab of the encyclopedia (game_data/www-heroes/UI/Doc/Heroes)."""

import os
import re
from common import Generator, GAME_DATA, warn, load_xdb, as_list, items, href_path, game_path, find_icon_size

gen = Generator("templates-heroes", __doc__)

heroes_xdb_path = os.path.join(GAME_DATA, "heroes", "MapObjects")
lua_scripts_path = os.path.join(GAME_DATA, "lua", "scripts")
heroes_pedia_path = os.path.join(GAME_DATA, "www-heroes", "UI", "Doc", "Heroes")
numbers_txt_path = os.path.join(GAME_DATA, "www", "UI", "Doc", "Common", "N")
hero_lua_regex = r"(H_[A-Z0-9_]+) = '([A-Za-z0-9]+)'"
army_lua_regex = r".* = {(.*)},"

# MapObjects folder -> (encyclopedia folder, id of the faction window)
factions = {
    "Haven": ("Haven", "000001"),
    "Inferno": ("Inferno", "000002"),
    "Necropolis": ("Necro", "000003"),
    "Preserve": ("Preserve", "000004"),
    "Dungeon": ("Dungeon", "000005"),
    "Academy": ("Academy", "000006"),
    "Dwarves": ("Fortress", "000007"),
    "Stronghold": ("Stronghold", "000008"),
    #"Neutral": ("Neutral", "000009"),
}

masteries = {
    "MASTERY_NONE": 0,
    "MASTERY_BASIC": 1,
    "MASTERY_ADVANCED": 2,
    "MASTERY_EXPERT": 3,
    "MASTERY_EXTRA_EXPERT": 4
}

war_machines = [
    ("Ballista", "WAR_MACHINE_BALLISTA", "/Text/Game/Creatures/WarMachines/Ballista.txt"),
    ("FirstAidTent", "WAR_MACHINE_FIRST_AID_TENT", "/Text/Game/Creatures/WarMachines/FirstAidTent.txt"),
    ("AmmoCart", "WAR_MACHINE_AMMO_CART", "/Text/Game/Creatures/WarMachines/AmmoCart.txt"),
]

# Layout slots, index 0 is unused: the max number of elements is len(...) - 1
button_pos = [0, 2, 62, 122, 182, 242, 302, 362, 422, 482, 542, 602, 662]
creature_pos = [0, 163, 224, 285, 346, 407]
icon_pos = [0, 100, 170, 240, 310, 380, 100, 170, 240, 310, 380]
icon_line = [0, 14, 14, 14, 14, 14, 84, 84, 84, 84, 84]
stats = {
    "Att": {"name": "Offence", "pos": 0, "prob": "OffenceProb"},
    "Def": {"name": "Defence", "pos": 80, "prob": "DefenceProb"},
    "Spp": {"name": "SpellPower", "pos": 160, "prob": "SpellpowerProb"},
    "Klg": {"name": "Knowledge", "pos": 240, "prob": "KnowledgeProb"},
}


def index_table(xdb, table, key="ID"):
    return {item[key]: item for item in as_list(xdb[table]["objects"]["Item"])}

classes = index_table(load_xdb(GAME_DATA, "heroes", "GameMechanics", "RefTables", "HeroClass.xdb"), "Table_HeroClassDesc_HeroClass")
skills = index_table(load_xdb(GAME_DATA, "skills", "GameMechanics", "RefTables", "Skills.xdb"), "Table_HeroSkill_SkillID")
spells = index_table(load_xdb(GAME_DATA, "spells", "GameMechanics", "RefTables", "UndividedSpells.xdb"), "Table_Spell_SpellID")
creatures = index_table(load_xdb(GAME_DATA, "creatures", "GameMechanics", "RefTables", "Creatures.xdb"), "Table_Creature_CreatureType")

with open(os.path.join(lua_scripts_path, "game", "heroes.lua"), 'r') as heroes_lua:
    heroes_lua_lines = heroes_lua.readlines()
with open(os.path.join(lua_scripts_path, "advmap", "handlers", "starting-armies.lua"), 'r') as armies_lua:
    armies_lua_lines = armies_lua.readlines()


def hero_file(hero, faction, filename, subfolder=None):
    return os.path.join(heroes_pedia_path, faction, hero, *([subfolder] if subfolder else []), filename)

def shared_file(folder, filename):
    return os.path.join(heroes_pedia_path, folder, filename)

def get_hero_lua_name(hero_id):
    for line in heroes_lua_lines:
        regmatch = re.match(hero_lua_regex, line)
        if regmatch and regmatch.group(2) == hero_id:
            return regmatch.group(1)
    warn(f"hero with name {hero_id} not found in heroes.lua")
    return None

def get_hero_starting_army(hero_var, faction):
    """Returns [creature, count, creature, count, ...]: the hero's own army, else the faction default."""
    army = None
    for line in armies_lua_lines:
        if faction in line or hero_var in line:
            regmatch = re.match(army_lua_regex, line)
            if regmatch:
                army = regmatch.group(1)
    if not army:
        warn(f"army for {hero_var} or {faction} not found")
        return []
    return army.replace('{', '').replace('}', '').replace(' ', '').split(',')

def get_creature_visual(creature_id):
    if creature_id not in creatures:
        warn(f"creature {creature_id} not found")
        return None
    creature_path = href_path(creatures[creature_id]["Obj"]["@href"])
    visual_path = href_path(load_xdb(GAME_DATA, "creatures", creature_path)["Creature"]["Visual"]["@href"])
    return load_xdb(GAME_DATA, "creatures", visual_path)["CreatureVisual"]

def get_spell(spell_id):
    if spell_id not in spells:
        warn(f"spell with name {spell_id} not found")
        return None
    return load_xdb(GAME_DATA, "spells", href_path(spells[spell_id]["Obj"]["@href"]))["Spell"]

def get_skill(skill_id):
    if skill_id not in skills:
        warn(f"skill with name {skill_id} not found")
        return None
    return skills[skill_id]["obj"]

def prune_numbered(hero_id, faction, subfolder, prefix, count):
    """Removes the numbered element files (<hero>_<prefix><n>.*) beyond the current count."""
    folder = hero_file(hero_id, faction, "", subfolder)
    if os.path.isdir(folder):
        for file in os.listdir(folder):
            regmatch = re.match(rf"{re.escape(hero_id)}_{prefix}(\d+)\.", file)
            if regmatch and int(regmatch.group(1)) > count:
                gen.prune(os.path.join(folder, file))

def check_limit(hero_id, what, count, slots):
    if count >= len(slots):
        warn(f"{hero_id} has too many {what}, only {len(slots) - 1} can be displayed")
        return False
    return True


def generate_army(hero_id, faction, hero):
    """Creature stacks then war machines, returns the number of slots."""
    slots = []
    hero_var = get_hero_lua_name(hero_id)
    army = get_hero_starting_army(hero_var, faction) if hero_var else []
    for i in range(0, len(army) - 1, 2):
        creature_id = army[i]
        if creature_id == "CREATURE_ARCANE_EAGLE":
            creature_id = "CREATURE_SNOW_APE"
        visual = get_creature_visual(creature_id)
        if visual:
            slots.append((creature_id, visual['CreatureNameFileRef']['@href'], army[i+1], visual['Icon128']['@href']))
    for field, machine_id, name_ref in war_machines:
        if hero['Editable'][field] == "true":
            slots.append((machine_id, name_ref, None, None))

    counter = 0
    for creature_id, name_ref, count, icon in slots:
        if not check_limit(hero_id, "army slots", counter + 1, creature_pos):
            break
        counter += 1
        gen.log(creature_id)
        gen.write("heroarmyx.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_cr{counter}.(WindowSimple).xdb", "army"), {'hero': hero_id, 'creature': creature_id, 'x': counter, 'pos': creature_pos[counter], 'name_ref': name_ref, 'has_count': count is not None})
        if count is not None:
            gen.write_text(os.path.join(numbers_txt_path, f"{count}.txt"), count)
            gen.write("heroarmyx.(ForegroundTextString).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_cr{counter}.(ForegroundTextString).xdb", "army"), {'value': count})
            gen.write("windowshared.(WindowSimpleShared).xdb.j2", shared_file("_Creatures", f"{creature_id}.(WindowSimpleShared).xdb"), {'id': creature_id, 'size': 55})
            gen.write("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", shared_file("_Creatures", f"{creature_id}.(BackgroundSimpleScallingTexture).xdb"), {'path': icon, 'size': 128})
        else:
            count_file = hero_file(hero_id, faction, f"{hero_id}_cr{counter}.(ForegroundTextString).xdb", "army")
            if os.path.exists(count_file):
                gen.prune(count_file)
    prune_numbered(hero_id, faction, "army", "cr", counter)
    return counter


def generate_skills(hero_id, faction, hero):
    elements = []
    for skill in items(hero['Editable']['skills']):
        skill_mastery = masteries[skill['Mastery']]
        skill_data = get_skill(skill['SkillID'])
        if skill_data:
            elements.append((f"{skill['SkillID']}_{skill_mastery}", skill_data['NameFileRef']['Item'][skill_mastery-1]['@href'], skill_data['Texture']['Item'][skill_mastery]['@href']))
    for perk in items(hero['Editable']['perkIDs']):
        perk_data = get_skill(perk)
        if perk_data:
            elements.append((perk, perk_data['NameFileRef']['Item']['@href'], perk_data['Texture']['Item'][1]['@href']))

    counter = 0
    for skill_uid, name_ref, texture in elements:
        if not check_limit(hero_id, "skills and perks", counter + 1, icon_pos):
            break
        counter += 1
        gen.log(f"{skill_uid} {name_ref} {texture}")
        icon_size = find_icon_size(texture)
        gen.write("heroskillx.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_sk{counter}.(WindowSimple).xdb", "skills"), {'hero': hero_id, 'skill': skill_uid, 'x': counter, 'pos': icon_pos[counter], 'name_ref': name_ref})
        gen.write("windowshared.(WindowSimpleShared).xdb.j2", shared_file("_Skills", f"{skill_uid}.(WindowSimpleShared).xdb"), {'id': skill_uid, 'size': icon_size})
        gen.write("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", shared_file("_Skills", f"{skill_uid}.(BackgroundSimpleScallingTexture).xdb"), {'path': texture, 'size': icon_size})
    prune_numbered(hero_id, faction, "skills", "sk", counter)
    gen.write("heroskills.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_skills.(WindowSimple).xdb", "skills"), {'hero': hero_id})
    gen.write("heroskills.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_skills.(WindowSimpleShared).xdb", "skills"), {'hero': hero_id, 'nb': counter})


def generate_spells(hero_id, faction, hero):
    counter = 0
    for spell in items(hero['Editable']['spellIDs']):
        spell_data = get_spell(spell)
        if not spell_data:
            continue
        if not check_limit(hero_id, "spells", counter + 1, icon_pos):
            break
        counter += 1
        gen.log(spell)
        gen.write("herospellx.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_sp{counter}.(WindowSimple).xdb", "spells"), {'hero': hero_id, 'spell': spell, 'x': counter, 'pos': icon_pos[counter], 'line': icon_line[counter], 'name_ref': spell_data['NameFileRef']['@href']})
        gen.write("windowshared.(WindowSimpleShared).xdb.j2", shared_file("_Spells", f"{spell}.(WindowSimpleShared).xdb"), {'id': spell, 'size': 64})
        gen.write("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", shared_file("_Spells", f"{spell}.(BackgroundSimpleScallingTexture).xdb"), {'path': spell_data['Texture']['@href'], 'size': 128})
    prune_numbered(hero_id, faction, "spells", "sp", counter)
    gen.write("herospells.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_spells.(WindowSimple).xdb", "spells"), {'hero': hero_id})
    gen.write("herospells.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_spells.(WindowSimpleShared).xdb", "spells"), {'hero': hero_id, 'nb': counter})


def generate_hero(hero, faction, pos):
    hero_id = hero['InternalName']
    hero_name_file = hero['Editable']['NameFileRef']['@href']
    print(f"{faction}/{hero_id}")

    gen.write("herobutton.(WindowMSButton).xdb.j2", hero_file(hero_id, faction, f"{hero_id}.(WindowMSButton).xdb"), {'hero': hero_id, 'pos': pos, 'name_ref': hero_name_file})
    gen.write("herobutton.(WindowMSButtonShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}.(WindowMSButtonShared).xdb"), {'hero': hero_id})
    gen.write("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", hero_file(hero_id, faction, f"{hero_id}.(BackgroundSimpleScallingTexture).xdb"), {'path': hero['FaceTexture']['@href'], 'size': 128})
    gen.write("switch.(UISSendUIMessage).xdb.j2", hero_file(hero_id, faction, "SwitchOn.(UISSendUIMessage).xdb"), {'hero': hero_id, 'open': 1, 'close': 0})
    gen.write("switch.(UISSendUIMessage).xdb.j2", hero_file(hero_id, faction, "SwitchOff.(UISSendUIMessage).xdb"), {'hero': hero_id, 'open': 0, 'close': 1})
    gen.write("herowindow.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}.(WindowSimple).xdb"), {'hero': hero_id})
    gen.write("herowindow.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}.(WindowSimpleShared).xdb"), {'hero': hero_id})

    # Class: name, class name and attribute growth probabilities of the class
    gen.write("heroclass.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_class.(WindowSimple).xdb", "class"), {'hero': hero_id})
    gen.write("heroclass.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_class.(WindowSimpleShared).xdb", "class"), {'hero': hero_id})
    gen.write("heroname.(WindowTextView).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_name.(WindowTextView).xdb", "class"), {'hero': hero_id, 'name_ref': hero_name_file})
    if hero['Class'] in classes:
        heroclass = classes[hero['Class']]['obj']
        class_name_ref = heroclass['NameFileRef']['@href']
        if not class_name_ref.startswith('/'):
            class_name_ref = game_path("GameMechanics/RefTables", class_name_ref)
        gen.write("heroclass.(WindowTextView).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_class.(WindowTextView).xdb", "class"), {'hero': hero_id, 'class_ref': class_name_ref})
        for stat, stat_data in stats.items():
            statprob = heroclass['AttributeProbs'][stat_data['prob']]
            gen.write("herostatx.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_stat{stat}.(WindowSimple).xdb", "class"), {'hero': hero_id, 'stat': stat, 'name': stat_data['name'], 'pos': stat_data['pos']})
            gen.write("herostatx.(WindowTextView).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_stat{stat}.(WindowTextView).xdb", "class"), {'hero': hero_id, 'stat': stat, 'pos': 36+stat_data['pos'], 'value': statprob})
    else:
        warn(f"class with name {hero['Class']} not found")
    gen.write("herostat.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_stat.(WindowSimple).xdb", "class"), {'hero': hero_id})
    gen.write("herostat.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_stat.(WindowSimpleShared).xdb", "class"), {'hero': hero_id})

    # Army: hero face, creature stacks and war machines
    nb_slots = generate_army(hero_id, faction, hero)
    gen.write("heroarmy.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_army.(WindowSimple).xdb", "army"), {'hero': hero_id})
    gen.write("heroarmy.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_army.(WindowSimpleShared).xdb", "army"), {'hero': hero_id, 'nb': nb_slots})
    gen.write("heroface.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_face.(WindowSimple).xdb", "army"), {'hero': hero_id})
    gen.write("heroface.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_face.(WindowSimpleShared).xdb", "army"), {'hero': hero_id, 'faction': faction})

    # Specialization
    gen.write("herospec.(WindowSimple).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_spec.(WindowSimple).xdb", "spec"), {'hero': hero_id})
    gen.write("herospec.(WindowSimpleShared).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_spec.(WindowSimpleShared).xdb", "spec"), {'hero': hero_id})
    gen.write("herospec.(WindowTextView).xdb.j2", hero_file(hero_id, faction, f"{hero_id}_spec.(WindowTextView).xdb", "spec"), {'hero': hero_id, 'spec_ref': hero['SpecializationDescFileRef']['@href']})

    generate_skills(hero_id, faction, hero)
    generate_spells(hero_id, faction, hero)
    return hero_id


for folder, (faction, window_id) in factions.items():
    faction_heroes = []
    # Same order as Windows Explorer (NTFS sorts names case-insensitively, on upper case)
    for file in sorted(os.listdir(os.path.join(heroes_xdb_path, folder)), key=str.upper):
        hero_data = load_xdb(heroes_xdb_path, folder, file)
        if 'AdvMapHeroShared' not in hero_data:
            gen.log(f"{folder}/{file} is not a hero, skipped")
            continue
        if not check_limit(f"{faction} faction", "heroes", len(faction_heroes) + 1, button_pos):
            break
        faction_heroes.append(generate_hero(hero_data['AdvMapHeroShared'], faction, button_pos[len(faction_heroes) + 1]))

    # Faction lists: the hero buttons, and the faction window holding every hero window
    gen.write("factionbuttons.(WindowSimpleShared).xdb.j2", shared_file(faction, "Heroes.(WindowSimpleShared).xdb"), {'heroes': faction_heroes})
    gen.write("factionwindow.(WindowSimpleShared).xdb.j2", shared_file(faction, f"{window_id}.(WindowSimpleShared).xdb"), {'heroes': faction_heroes})

print(f"Done: {gen.written} files {'rendered (dry run)' if gen.dry_run else 'written'}")
