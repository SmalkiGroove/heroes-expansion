
import os
import xmltodict
import re
from jinja2 import Environment, FileSystemLoader

debug = False
dry_run = False

root_text_path = "../../game_texts/texts-EN"
heroes_xdb_path = "../../game_data/data/MapObjects"
reftable_xdb_path = "../../game_data/data/GameMechanics/RefTables"
armies_lua_path = "../../game_data/lua/scripts"
heroes_pedia_path = "../../game_data/doc/UI/Doc/Heroes"
hero_lua_regex = r"(H_[A-Z0-9_]+) = '([A-Za-z0-9]+)'"
army_lua_regex = r".* = {(.*)},"
army1_lua_regex = r'.*\[(H_[A-Z0-9_]+)\] = \{(.*)\},'
army2_lua_regex = r'.*\["([A-Za-z]+)"\] = \{(.*)\},'

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates-heroes"))

with open(os.path.join(reftable_xdb_path, "HeroClass.xdb"), 'r') as class_xdb:
    class_data = xmltodict.parse(class_xdb.read())
with open(os.path.join(reftable_xdb_path, "Skills.xdb"), 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())
with open(os.path.join(reftable_xdb_path, "UndividedSpells.xdb"), 'r') as spells_xdb:
    spells_data = xmltodict.parse(spells_xdb.read())
with open(os.path.join(reftable_xdb_path, "Creatures.xdb"), 'r') as creatures_xdb:
    creatures_data = xmltodict.parse(creatures_xdb.read())

def hero_base_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name)
def button_base_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(WindowMSButton).xdb")
def button_shared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(WindowMSButtonShared).xdb")
def button_background_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(BackgroundSimpleScallingTexture).xdb")
def hero_mainwindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(WindowSimple).xdb")
def hero_mainwindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(WindowSimpleShared).xdb")
def hero_switchon_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"SwitchOn.(UISSendUIMessage).xdb")
def hero_switchoff_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"SwitchOff.(UISSendUIMessage).xdb")
def hero_classwindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_class.(WindowSimple).xdb")
def hero_classwindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_class.(WindowSimpleShared).xdb")
def hero_classtext_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_class.(WindowTextView).xdb")
def hero_statwindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_stat.(WindowSimple).xdb")
def hero_statwindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_stat.(WindowSimpleShared).xdb")
def hero_statxwindow_path(name, faction, stat):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_stat{stat}.(WindowSimple).xdb")
def hero_statxtext_path(name, faction, stat):
    return os.path.join(heroes_pedia_path, faction, name, "class", f"{name}_stat{stat}.(WindowTextView).xdb")
def hero_armywindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "army", f"{name}_army.(WindowSimple).xdb")
def hero_armywindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "army", f"{name}_army.(WindowSimpleShared).xdb")
def hero_armyfacewindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "army", f"{name}_face.(WindowSimple).xdb")
def hero_armyfacewindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "army", f"{name}_face.(WindowSimpleShared).xdb")
def hero_armycrxwindow_path(name, faction, n):
    return os.path.join(heroes_pedia_path, faction, name, "army", f"{name}_cr{n}.(WindowSimple).xdb")
def hero_armycrxcounttext_path(name, faction, n):
    return os.path.join(heroes_pedia_path, faction, name, "army", f"{name}_cr{n}.(ForegroundTextString).xdb")
def hero_specwindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "spec", f"{name}_spec.(WindowSimple).xdb")
def hero_specwindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "spec", f"{name}_spec.(WindowSimpleShared).xdb")
def hero_spectext_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "spec", f"{name}_spec.(WindowTextView).xdb")
def hero_skillswindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "skills", f"{name}_skills.(WindowSimple).xdb")
def hero_skillswindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "skills", f"{name}_skills.(WindowSimpleShared).xdb")
def hero_skillxwindow_path(name, faction, n):
    return os.path.join(heroes_pedia_path, faction, name, "skills", f"{name}_sk{n}.(WindowSimple).xdb")
def hero_spellswindow_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "spells", f"{name}_spells.(WindowSimple).xdb")
def hero_spellswindowshared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, "spells", f"{name}_spells.(WindowSimpleShared).xdb")
def hero_spellxwindow_path(name, faction, n):
    return os.path.join(heroes_pedia_path, faction, name, "spells", f"{name}_sp{n}.(WindowSimple).xdb")
def skill_windowshared_path(skill):
    return os.path.join(heroes_pedia_path, "_Skills", f"{skill}.(WindowSimpleShared).xdb")
def skill_background_path(skill):
    return os.path.join(heroes_pedia_path, "_Skills", f"{skill}.(BackgroundSimpleScallingTexture).xdb")
def creature_windowshared_path(creature):
    return os.path.join(heroes_pedia_path, "_Creatures", f"{creature}.(WindowSimpleShared).xdb")
def creature_background_path(creature):
    return os.path.join(heroes_pedia_path, "_Creatures", f"{creature}.(BackgroundSimpleScallingTexture).xdb")
def spell_windowshared_path(spell):
    return os.path.join(heroes_pedia_path, "_Spells", f"{spell}.(WindowSimpleShared).xdb")
def spell_background_path(spell):
    return os.path.join(heroes_pedia_path, "_Spells", f"{spell}.(BackgroundSimpleScallingTexture).xdb")

def write_from_template(tpl_name, output_path, variables):
    tpl = jinja_env.get_template(tpl_name)
    rendered = tpl.render(variables)
    if not dry_run:
        with open(output_path, 'w') as out_file:
            out_file.write(rendered)

def log(msg):
    if debug:
        print(msg)

def get_hero_lua_name(hero_id):
    with open(os.path.join(armies_lua_path, "game", "heroes.lua"), 'r') as heroes_lua:
        for line in heroes_lua.readlines():
            regmatch = re.match(hero_lua_regex, line)
            if regmatch and len(regmatch.groups()) == 2:
                if regmatch.group(2) == hero_id:
                    return regmatch.group(1)
    print(f"WARN: hero with name {hero_id} not found")
    return None
def get_hero_starting_army(hero_id, faction):
    army = None
    with open(os.path.join(armies_lua_path, "advmap", "handlers", "starting-armies.lua"), 'r') as armies_lua:
        for line in armies_lua.readlines():
            if faction in line:
                regmatch = re.match(army_lua_regex, line)
                if regmatch:
                    army = regmatch.group(1)
            if hero_id in line:
                regmatch = re.match(army_lua_regex, line)
                if regmatch:
                    army = regmatch.group(1)
    if army:
        return army
    else:
        print(f"WARN: army for {hero_id} or {faction} not found")
    return None
def get_creature_data(creature_id):
    for creature in creatures_data["Table_Creature_CreatureType"]["objects"]["Item"]:
        if creature["ID"] == creature_id:
            creature_path = creature["Obj"]["@href"][1:-20]
            with open(os.path.join("../../game_data/data", creature_path), 'r') as creature_xdb:
                creaturevisual_path = xmltodict.parse(creature_xdb.read())["Creature"]["Visual"]["@href"][1:-26]
                with open(os.path.join("../../game_data/characters", creaturevisual_path), 'r') as creature_visual_xdb:
                    return xmltodict.parse(creature_visual_xdb.read())["CreatureVisual"]
def get_class_data(class_id):
    for heroclass in class_data["Table_HeroClassDesc_HeroClass"]["objects"]["Item"]:
        if heroclass["ID"] == class_id:
            return heroclass["obj"]
    print(f"WARN: class with name {class_id} not found")
    return None
def get_skill_data(skill_id):
    for skill in skills_data["Table_HeroSkill_SkillID"]["objects"]["Item"]:
        if skill["ID"] == skill_id:
            return skill["obj"]
    print(f"WARN: skill with name {skill_id} not found")
    return None
def get_spell_data(spell_id):
    for spell in spells_data["Table_Spell_SpellID"]["objects"]["Item"]:
        if spell["ID"] == spell_id:
            spell_path = spell["Obj"]["@href"][1:-17]
            with open(os.path.join("../../game_data/data", spell_path), 'r') as spell_xdb:
                return xmltodict.parse(spell_xdb.read())["Spell"]
    print(f"WARN: spell with name {spell_id} not found")
    return None

factions = {
    "Haven": "Haven",
    "Preserve": "Preserve",
    "Dwarves" : "Fortress",
    "Academy": "Academy",
    "Dungeon": "Dungeon",
    "Necropolis": "Necro",
    "Inferno": "Inferno",
    "Stronghold": "Stronghold",
    "Neutral": "Neutral"
}

masteries = {
    "MASTERY_NONE": 0,
    "MASTERY_BASIC": 1,
    "MASTERY_ADVANCED": 2,
    "MASTERY_EXPERT": 3,
    "MASTERY_EXTRA_EXPERT": 4
}

button_pos = [0, 2, 62, 122, 182, 242, 302, 362, 422, 482, 542, 602, 662]
creature_pos = [0, 163, 224, 285, 346, 407]
icon_pos = [0, 100, 170, 240, 310, 380, 100, 170, 240, 310, 380]
icon_line = [0, 14, 14, 14, 14, 14, 84, 84, 84, 84, 84]
subfolders = ["class", "army", "spec", "skills", "spells"]
stats = {
    "Att": {"name": "Offence", "pos": 0, "prob": "OffenceProb"},
    "Def": {"name": "Defence", "pos": 80, "prob": "DefenceProb"},
    "Spp": {"name": "SpellPower", "pos": 160, "prob": "SpellpowerProb"},
    "Klg": {"name": "Knowledge", "pos": 240, "prob": "KnowledgeProb"},
}
counter = 0
hero_counter = 0

for folder,faction in factions.items():
    hero_counter = 0
    for file in os.listdir(os.path.join(heroes_xdb_path, folder)):
        print("\n")
        print("===============================================")
        print(file)
        print("===============================================")
        with open(os.path.join(heroes_xdb_path, folder, file), 'r') as xdb_file:
            hero_data = xmltodict.parse(xdb_file.read())
        
        if 'AdvMapHeroShared' in hero_data:
            hero_counter += 1
            hero_id = hero_data['AdvMapHeroShared']['InternalName']
            hero_class = hero_data['AdvMapHeroShared']['Class']
            hero_name_file = hero_data['AdvMapHeroShared']['Editable']['NameFileRef']['@href']
            hero_spec_file = hero_data['AdvMapHeroShared']['SpecializationDescFileRef']['@href']
            hero_face_file = hero_data['AdvMapHeroShared']['FaceTexture']['@href']
            hero_skills = hero_data['AdvMapHeroShared']['Editable']['skills']['Item']
            if not isinstance(hero_skills, list):
                hero_skills = [hero_skills]
            hero_perks = hero_data['AdvMapHeroShared']['Editable']['perkIDs']['Item']
            if not isinstance(hero_perks, list):
                hero_perks = [hero_perks]
            hero_spells = hero_data['AdvMapHeroShared']['Editable']['spellIDs']['Item'] if hero_data['AdvMapHeroShared']['Editable']['spellIDs'] else []
            if not isinstance(hero_spells, list):
                hero_spells = [hero_spells]

            log(hero_id)
            log(hero_class)
            log(hero_name_file)
            log(hero_face_file)
            log(hero_skills)
            log(hero_perks)
            log(hero_spells)

            hero_doc_path = hero_base_path(hero_id, faction)
            os.makedirs(hero_doc_path, exist_ok=True)
            for subf in subfolders:
                os.makedirs(os.path.join(hero_doc_path, subf), exist_ok=True)

            write_from_template("herobutton.(WindowMSButton).xdb.j2", button_base_path(hero_id, faction), {'hero': hero_id, 'pos': button_pos[hero_counter], 'name_ref': hero_name_file})
            write_from_template("herobutton.(WindowMSButtonShared).xdb.j2", button_shared_path(hero_id, faction), {'hero': hero_id})
            write_from_template("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", button_background_path(hero_id, faction), {'path': hero_face_file, 'size': 128})
            write_from_template("switch.(UISSendUIMessage).xdb.j2", hero_switchon_path(hero_id, faction), {'hero': hero_id, 'open': 1, 'close': 0})
            write_from_template("switch.(UISSendUIMessage).xdb.j2", hero_switchoff_path(hero_id, faction), {'hero': hero_id, 'open': 0, 'close': 1})
            
            write_from_template("herowindow.(WindowSimple).xdb.j2", hero_mainwindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("herowindow.(WindowSimpleShared).xdb.j2", hero_mainwindowshared_path(hero_id, faction), {'hero': hero_id})

            write_from_template("heroclass.(WindowSimple).xdb.j2", hero_classwindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("heroclass.(WindowSimpleShared).xdb.j2", hero_classwindowshared_path(hero_id, faction), {'hero': hero_id})
            heroclass_data = get_class_data(hero_class)
            class_name_ref = os.path.join("/GameMechanics/RefTables", heroclass_data['NameFileRef']['@href'])
            write_from_template("heroclass.(WindowTextView).xdb.j2", hero_classtext_path(hero_id, faction), {'hero': hero_id, 'class_ref': class_name_ref})
            write_from_template("herostat.(WindowSimple).xdb.j2", hero_statwindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("herostat.(WindowSimpleShared).xdb.j2", hero_statwindowshared_path(hero_id, faction), {'hero': hero_id})
            for stat,stat_data in stats.items():
                statprob = heroclass_data['AttributeProbs'][stat_data['prob']]
                write_from_template("herostatx.(WindowSimple).xdb.j2", hero_statxwindow_path(hero_id, faction, stat), {'hero': hero_id, 'stat': stat, 'name': stat_data['name'], 'pos': stat_data['pos']})
                write_from_template("herostatx.(WindowTextView).xdb.j2", hero_statxtext_path(hero_id, faction, stat), {'hero': hero_id, 'stat': stat, 'pos': 36+stat_data['pos'], 'value': statprob})

            write_from_template("heroarmy.(WindowSimple).xdb.j2", hero_armywindow_path(hero_id, faction), {'hero': hero_id})
            counter = 0
            hero_var = get_hero_lua_name(hero_id)
            if hero_var:
                hero_army = get_hero_starting_army(hero_var, faction)
                if hero_army:
                    hero_army = hero_army.replace('{','').replace('}','').replace(' ','').split(',')
                    log(hero_army)
                    write_from_template("heroarmy.(WindowSimpleShared).xdb.j2", hero_armywindowshared_path(hero_id, faction), {'hero': hero_id, 'nb': len(hero_army)})
                    for i in range(0, len(hero_army), 2):
                        counter += 1
                        creature_id = hero_army[i]
                        if creature_id == "CREATURE_ARCANE_EAGLE":
                            creature_id = "CREATURE_SNOW_APE"
                        log(creature_id)
                        creature_data = get_creature_data(creature_id)
                        with open(os.path.join(heroes_pedia_path, 'Common', 'CreatureCount', f'{hero_army[i+1]}.txt'), 'w', encoding='utf-16') as creature_count_file:
                            creature_count_file.write(hero_army[i+1])
                        write_from_template("heroarmyx.(WindowSimple).xdb.j2", hero_armycrxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'creature': creature_id, 'x': counter, 'pos': creature_pos[counter], 'name_ref': creature_data['CreatureNameFileRef']['@href']})
                        write_from_template("heroarmyx.(ForegroundTextString).xdb.j2", hero_armycrxcounttext_path(hero_id, faction, counter), {'value': hero_army[i+1]})
                        write_from_template("windowshared.(WindowSimpleShared).xdb.j2", creature_windowshared_path(creature_id), {'id': creature_id, 'size': 55})
                        write_from_template("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", creature_background_path(creature_id), {'path': creature_data['Icon128']['@href'], 'size': 128})
            if hero_data['AdvMapHeroShared']['Editable']['Ballista']:
                counter += 1
                write_from_template("heroarmyx.(WindowSimple).xdb.j2", hero_armycrxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'creature': 'WAR_MACHINE_BALLISTA', 'x': counter, 'pos': creature_pos[counter], 'name_ref': "/Text/Game/Creatures/WarMachines/Ballista.txt"})
            if hero_data['AdvMapHeroShared']['Editable']['FirstAidTent']:
                counter += 1
                write_from_template("heroarmyx.(WindowSimple).xdb.j2", hero_armycrxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'creature': 'WAR_MACHINE_FIRST_AID_TENT', 'x': counter, 'pos': creature_pos[counter], 'name_ref': "/Text/Game/Creatures/WarMachines/FirstAidTent.txt"})
            if hero_data['AdvMapHeroShared']['Editable']['AmmoCart']:
                counter += 1
                write_from_template("heroarmyx.(WindowSimple).xdb.j2", hero_armycrxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'creature': 'WAR_MACHINE_AMMO_CART', 'x': counter, 'pos': creature_pos[counter], 'name_ref': "/Text/Game/Creatures/WarMachines/AmmoCart.txt"})
            write_from_template("heroface.(WindowSimple).xdb.j2", hero_armyfacewindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("heroface.(WindowSimpleShared).xdb.j2", hero_armyfacewindowshared_path(hero_id, faction), {'hero': hero_id, 'faction': faction})

            write_from_template("herospec.(WindowSimple).xdb.j2", hero_specwindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("herospec.(WindowSimpleShared).xdb.j2", hero_specwindowshared_path(hero_id, faction), {'hero': hero_id})
            write_from_template("herospec.(WindowTextView).xdb.j2", hero_spectext_path(hero_id, faction), {'hero': hero_id, 'spec_ref': hero_spec_file})

            write_from_template("heroskills.(WindowSimple).xdb.j2", hero_skillswindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("heroskills.(WindowSimpleShared).xdb.j2", hero_skillswindowshared_path(hero_id, faction), {'hero': hero_id, 'nb': len(hero_skills)+len(hero_perks)})
            counter = 0
            for skill in hero_skills:
                counter += 1
                skill_mastery = masteries[skill['Mastery']]
                skill_id = skill['SkillID']
                skill_uid = f"{skill_id}_{skill_mastery}"
                log(skill_id)
                skill_data = get_skill_data(skill_id)
                skill_name_file = skill_data['NameFileRef']['Item'][skill_mastery-1]['@href']
                skill_texture_path = skill_data['Texture']['Item'][skill_mastery]['@href']
                log(skill_name_file)
                log(skill_texture_path)
                write_from_template("heroskillx.(WindowSimple).xdb.j2", hero_skillxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'skill': skill_uid, 'x': counter, 'pos': icon_pos[counter], 'name_ref': skill_name_file})
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", skill_windowshared_path(skill_uid), {'id': skill_uid, 'size': 64})
                write_from_template("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", skill_background_path(skill_uid), {'path': skill_texture_path, 'size': 64})
            for perk in hero_perks:
                counter += 1
                log(perk)
                perk_data = get_skill_data(perk)
                perk_name_file = perk_data['NameFileRef']['Item']['@href']
                perk_texture_path = perk_data['Texture']['Item'][1]['@href']
                log(perk_name_file)
                log(perk_texture_path)
                write_from_template("heroskillx.(WindowSimple).xdb.j2", hero_skillxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'skill': perk, 'x': counter, 'pos': icon_pos[counter], 'name_ref': perk_name_file})
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", skill_windowshared_path(perk), {'id': perk, 'size': 64})
                write_from_template("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", skill_background_path(perk), {'path': perk_texture_path, 'size': 64})

            write_from_template("herospells.(WindowSimple).xdb.j2", hero_spellswindow_path(hero_id, faction), {'hero': hero_id})
            write_from_template("herospells.(WindowSimpleShared).xdb.j2", hero_spellswindowshared_path(hero_id, faction), {'hero': hero_id, 'nb': len(hero_spells)})
            counter = 0
            for spell in hero_spells:
                counter += 1
                log(spell)
                spell_data = get_spell_data(spell)
                spell_name_file = spell_data['NameFileRef']['@href']
                spell_texture_path = spell_data['Texture']['@href']
                log(spell_name_file)
                log(spell_texture_path)
                write_from_template("herospellx.(WindowSimple).xdb.j2", hero_spellxwindow_path(hero_id, faction, counter), {'hero': hero_id, 'spell': spell, 'x': counter, 'pos': icon_pos[counter], 'line': icon_line[counter], 'name_ref': spell_name_file})
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", spell_windowshared_path(spell), {'id': spell, 'size': 64})
                write_from_template("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", spell_background_path(spell), {'path': spell_texture_path, 'size': 128})

            print("Done")
        else:
            print("Not a hero. Next")
