
import os
import xmltodict
from jinja2 import Environment, FileSystemLoader

root_text_path = "../../game_texts/texts-EN"
heroes_xdb_path = "../../game_data/data/MapObjects"
skills_xdb_path = "../../game_data/data/GameMechanics/RefTables/Skills.xdb"
spells_xdb_path = "../../game_data/data/GameMechanics/RefTables/UndividedSpells.xdb"
creatures_xdb_path = "../../game_data/data/GameMechanics/RefTables/Creatures.xdb"
heroes_pedia_path = "../../game_data/doc/UI/Doc/Heroes"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates-heroes"))

STARTING_ARMIES = {
    # haven
    "Haven": { {CREATURE_PEASANT,90}, {CREATURE_ARCHER,40}, {CREATURE_FOOTMAN,22} },
    "H_MAEVE": { {CREATURE_PEASANT,75}, {CREATURE_PEASANT,75} },
    "H_DOUGAL": { {CREATURE_ARCHER,30}, {CREATURE_ARCHER,30}, {CREATURE_FOOTMAN,30} },
    "H_LASZLO": { {CREATURE_FOOTMAN,20}, {CREATURE_FOOTMAN,20} },
    "H_KLAUS": { {CREATURE_ARCHER,30}, {CREATURE_FOOTMAN,20}, {CREATURE_CAVALIER,1} },
    "H_ALARIC": { {CREATURE_PEASANT,100}, {CREATURE_PRIEST,2} },
    "H_GABRIELLE": { {CREATURE_GRIFFIN,11} },
    # preserve
    "Preserve": { {CREATURE_BLADE_JUGGLER,57}, {CREATURE_PIXIE,29}, {CREATURE_WOOD_ELF,18} },
    "H_IVOR": { {CREATURE_WOLF,20}, {CREATURE_WOLF,20} },
    "H_TALANAR": { {CREATURE_BLADE_JUGGLER,57}, {CREATURE_WOOD_ELF,18}, {CREATURE_DRUID,4} },
    "H_FINDAN": { {CREATURE_WOOD_ELF,14}, {CREATURE_WOOD_ELF,14} },
    "H_DIRAEL": { {CREATURE_BLADE_JUGGLER,45}, {CREATURE_SPRITE,35} },
    "H_TIERU": { {CREATURE_BLADE_JUGGLER,38}, {CREATURE_PIXIE,22}, {CREATURE_DRUID,8} },
    "H_YLTHIN": { {CREATURE_PIXIE,22}, {CREATURE_WOOD_ELF,14}, {CREATURE_UNICORN,3} },
    # academy
    "Academy": { {CREATURE_GREMLIN,76}, {CREATURE_STONE_GARGOYLE,42}, {CREATURE_IRON_GOLEM,22} },
    "H_HAVEZ": { {CREATURE_GREMLIN,51}, {CREATURE_GREMLIN,51} },
    "H_RAZZAK": { {CREATURE_STONE_GARGOYLE,50}, {CREATURE_IRON_GOLEM,30} },
    "H_GALIB": { {CREATURE_STONE_GARGOYLE,33}, {CREATURE_IRON_GOLEM,20}, {CREATURE_GENIE,2} },
    "H_DAVIUS": { {CREATURE_GREMLIN,89}, {CREATURE_RAKSHASA,1} },
    "H_CYRUS": { {CREATURE_GREMLIN,51}, {CREATURE_IRON_GOLEM,20}, {CREATURE_MAGI,8} },
    "H_MINASLI": { {CREATURE_GREMLIN,51}, {CREATURE_STONE_GARGOYLE,33}, {CREATURE_ARCANE_EAGLE,1} },
    # fortress
    "Fortress": { {CREATURE_DEFENDER,72}, {CREATURE_AXE_FIGHTER,38}, {CREATURE_BROWLER,21} },
    "H_INGVAR": { {CREATURE_DEFENDER,60}, {CREATURE_DEFENDER,60} },
    "H_KARLI": { {CREATURE_DEFENDER,48}, {CREATURE_AXE_FIGHTER,48} },
    "H_ROLF": { {CREATURE_BEAR_RIDER,6}, {CREATURE_BEAR_RIDER,6} },
    "H_TAZAR": { {CREATURE_AXE_FIGHTER,28}, {CREATURE_BROWLER,19}, {CREATURE_BEAR_RIDER,4} },
    "H_HANGVUL": { {CREATURE_BROWLER,29}, {CREATURE_THUNDER_THANE,1} },
    "H_ERLING": { {CREATURE_DEFENDER,48}, {CREATURE_BROWLER,19}, {CREATURE_RUNE_MAGE,3} },
    # necropolis
    "Necro": { {CREATURE_SKELETON,85}, {CREATURE_WALKING_DEAD,45}, {CREATURE_MANES,21} },
    "H_ORSON": { {CREATURE_WALKING_DEAD,19}, {CREATURE_WALKING_DEAD,19}, {CREATURE_WALKING_DEAD,19} },
    "H_LUCRETIA": { {CREATURE_WALKING_DEAD,39}, {CREATURE_MANES,19}, {CREATURE_VAMPIRE,5} },
    "H_XERXON": { {CREATURE_SKELETON,78}, {CREATURE_MANES,18}, {CREATURE_BLACK_KNIGHT,1} },
    "H_THANT": { {CREATURE_SKELETON,57}, {CREATURE_WALKING_DEAD,39}, {CREATURE_MUMMY,19} },
    "H_SANDRO": { {CREATURE_SKELETON,63}, {CREATURE_MANES,23}, {CREATURE_LICH,3} },
    "H_ORNELLA": { {CREATURE_SKELETON,70}, {CREATURE_MANES,22}, {CREATURE_VAMPIRE,2} },
    # inferno
    "Inferno": { {CREATURE_FAMILIAR,99}, {CREATURE_DEMON,44}, {CREATURE_HELL_HOUND,22} },
    "H_GRAWL": { {CREATURE_HELL_HOUND,13}, {CREATURE_HELL_HOUND,13}, {CREATURE_HELL_HOUND,13} },
    "H_GROK": { {CREATURE_FAMILIAR,70}, {CREATURE_HELL_HOUND,30}, {CREATURE_NIGHTMARE,2} },
    "H_BIARA": { {CREATURE_FAMILIAR,66}, {CREATURE_DEMON,36}, {CREATURE_SUCCUBUS,9} },
    "H_ORLANDO": { {CREATURE_DEMON,55}, {CREATURE_HELL_HOUND,25} },
    "H_KHABELETH": { {CREATURE_FAMILIAR,111}, {CREATURE_DEMON,55} },
    # dungeon
    "Dungeon": { {CREATURE_SCOUT,58}, {CREATURE_WITCH,32}, {CREATURE_MINOTAUR,18} },
    "H_VAYSHAN": { {CREATURE_SCOUT,39}, {CREATURE_SCOUT,39} },
    "H_YRWANNA": { {CREATURE_WITCH,23}, {CREATURE_WITCH,23} },
    "H_DARKSTORM": { {CREATURE_MINOTAUR,16}, {CREATURE_MINOTAUR,16} },
    "H_SORGAL": { {CREATURE_SCOUT,45}, {CREATURE_MINOTAUR,19}, {CREATURE_RIDER,5} },
    "H_ERUINA": { {CREATURE_SCOUT,45}, {CREATURE_MINOTAUR,19}, {CREATURE_MATRON,2} },
    "H_SHADYA": { {CREATURE_WITCH,36}, {CREATURE_SHADOW_MISTRESS,2} },
    "H_LETHOS": { {CREATURE_SCOUT,39}, {CREATURE_WITCH,23}, {CREATURE_MANTICORE,3} },
    # stronghold
    "Stronghold": { {CREATURE_GOBLIN,82}, {CREATURE_SHAMAN,38}, {CREATURE_ORC_WARRIOR,23} },
    "H_KILGHAN": { {CREATURE_GOBLIN,80}, {CREATURE_GOBLIN,80} },
    "H_TELSEK": { {CREATURE_ORC_WARRIOR,20}, {CREATURE_ORC_WARRIOR,20} },
    "H_GARUNA": { {CREATURE_GOBLIN,69}, {CREATURE_ORC_WARRIOR,21}, {CREATURE_CENTAUR,5} },
    "H_GORSHAK": { {CREATURE_SHAMAN,38}, {CREATURE_ORC_WARRIOR,23}, {CREATURE_ORCCHIEF_BUTCHER,3} },
    "H_KARUKAT": { {CREATURE_GOBLIN,69}, {CREATURE_SHAMAN,33}, {CREATURE_WYVERN,1} },
    "H_KUJIN": { {CREATURE_GOBLIN,55}, {CREATURE_SHAMAN_WITCH,23}, {CREATURE_SHAMAN_WITCH,23} },
}

with open(skills_xdb_path, 'r') as skills_xdb:
    skills_data = xmltodict.parse(skills_xdb.read())
with open(spells_xdb_path, 'r') as spells_xdb:
    spells_data = xmltodict.parse(spells_xdb.read())
with open(creatures_xdb_path, 'r') as creatures_xdb:
    creatures_data = xmltodict.parse(creatures_xdb.read())

def button_base_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(WindowMSButton).xdb")
def button_shared_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(WindowMSButtonShared).xdb")
def button_background_path(name, faction):
    return os.path.join(heroes_pedia_path, faction, name, f"{name}.(BackgroundSimpleScallingTexture).xdb")
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
    with open(output_path, 'w') as out_file:
        out_file.write(rendered)

def get_skill_data(skill_id):
    for skill in skills_data["Table_HeroSkill_SkillID"]["objects"]["Item"]:
        if skill["ID"] == skill_id:
            return skill["obj"]
    print(f"WARN: skill with name {skill_id} not found")
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
}

icon_pos = [0, 100, 170, 240, 310, 380]

for folder,faction in factions.items():
    for file in os.listdir(os.path.join(heroes_xdb_path, folder)):
        with open(os.path.join(heroes_xdb_path, folder, file), 'r') as xdb_file:
            hero_data = xmltodict.parse(xdb_file.read())
        if 'AdvMapHeroShared' in hero_data:
            hero_id = hero_data['AdvMapHeroShared']['InternalName']
            hero_class = hero_data['AdvMapHeroShared']['Class']
            hero_name_file = hero_data['AdvMapHeroShared']['Editable']['NameFileRef']['@href']
            hero_face_file = hero_data['AdvMapHeroShared']['FaceTexture']
            hero_skills = hero_data['AdvMapHeroShared']['Editable']['skills']['Item']
            hero_perks = hero_data['AdvMapHeroShared']['Editable']['perkIDs']['Item']
            hero_spells = hero_data['AdvMapHeroShared']['Editable']['spellIDs']['Item']
            for skill in hero_skills:
                skill_mastery = masteries[skill['Mastery']]
                skill_id = f"{skill['SkillID']}_{skill_mastery}"
                skill_data = get_skill_data(skill_id)
                skill_name_file = skill_data['NameFileRef']['Item'][skill_mastery-1]['@href']
                skill_texture_path = skill_data['Texture']['Item'][skill_mastery]['@href']
                write_from_template("windowshared.(WindowSimpleShared).xdb.j2", skill_windowshared_path(skill_id), {'id': skill_id})
                write_from_template("windowbg.(BackgroundSimpleScallingTexture).xdb.j2", skill_background_path(skill_id), {'path': skill_texture_path, 'size': 64})

