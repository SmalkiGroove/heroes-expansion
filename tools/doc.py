import os
import re
import yaml
import xmltodict

# MARKDOWN TEXT GENERATOR FOR README
# USAGE : python doc.py ...

workdir = os.path.dirname(os.path.abspath(__file__))
reference_file = os.path.join(workdir, "doc-refs.yml")
doc_path = "../doc"

root_path_data = "../game_data/data"
root_text_path = "../game_texts/texts-EN"

### CREATURES
###############################################################################################################################################################
#
path_to_creatures = "../game_data/data/GameMechanics/Creature/Creatures"
path_to_allspells = "../game_data/data/GameMechanics/RefTables/UndividedSpells.xdb"
path_to_abilities = "../game_data/data/GameMechanics/RefTables/CombatAbilities.xdb"

def get_spell_name(id):
    with open(os.path.join(workdir, path_to_allspells), 'r') as xdb:
        allspells = xmltodict.parse(xdb.read())
    for item in allspells['Table_Spell_SpellID']['objects']['Item']:
        if item['ID'] == id:
            spell_path = os.path.join(workdir, root_path_data + item['Obj']['@href'].replace('#xpointer(/Spell)',''))
            with open(spell_path, 'r', encoding='utf-8-sig') as spell_file:
                # print(spell_path)
                # print(spell_file.readline())
                spl = xmltodict.parse(spell_file.read())
            name_path = os.path.join(workdir, root_text_path + spl['Spell']['NameFileRef']['@href'])
            with open(name_path, 'r', encoding='utf-16') as name_file:
                return name_file.read()
    print(f"Spell '{id}' not found")
    return id

def get_spells_text(spells):
    if isinstance(spells, list):
        return ', '.join([f"{get_spell_name(spell['Spell'])} ({spell['Mastery'].replace('MASTERY_','').lower()})" for spell in spells])
    else:
        return f"{get_spell_name(spells['Spell'])} ({spells['Mastery'].replace('MASTERY_','').lower()})"

def get_ability_name(id):
    with open(os.path.join(workdir, path_to_abilities), 'r') as xdb:
        abilities = xmltodict.parse(xdb.read())
    for item in abilities['Table_CreatureAbility_CombatAbility']['objects']['Item']:
        if item['ID'] == id:
            name_path = os.path.join(workdir, root_text_path + item['obj']['NameFileRef']['@href'])
            with open(name_path, 'r', encoding='utf-16') as name_file:
                return name_file.read()
    print(f"Ability '{id}' not found")
    return id

def get_abilities_text(abilities):
    if isinstance(abilities, list):
        return ', '.join([f"{get_ability_name(ability)}" for ability in abilities])
    else:
        return f"{get_ability_name(abilities)}"

def creature_doc_line(tier, upg, name, path):
    print(f"Creature {name}")
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
        spells = get_spells_text(creature['Creature']['KnownSpells']['Item'])
    else:
        spells = "_none_"
    if creature['Creature']['Abilities']:
        abilities = get_abilities_text(creature['Creature']['Abilities']['Item'])
    else:
        abilities = '_none_'
    return f"| {name} | {tier} | {growth} | {hp} | {atk} | {dfs} | {dmg} | {spd} | {init} | {spells} | {abilities} |"

def generate_creature_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'CREATURES.md'), 'w')
    print("# CREATURES DOCUMENTATION", file=out)
    for faction in ref_data.keys():
        print("", file=out)
        print(f"### {faction}:", file=out)
        print("| CREATURE | TIER | NB | HP | ATT | DEF | DMG± | SPD | INIT | SPELLS | ABILITIES |", file=out)
        print("|----------|------|----|----|-----|-----|------|-----|------|--------|-----------|", file=out)
        last_tier = 1
        for c in ref_data[faction]:
            name = c['name']
            tier = c['tier']
            upg = c['upgrade']
            if last_tier != tier:
                last_tier = tier
                print("| | | | | | | | | | | |", file=out)
            path = os.path.join(workdir, path_to_creatures, c['path'])
            line = creature_doc_line(tier, upg, name, path)
            print(line, file=out)
    out.close()
#
###############################################################################################################################################################

### HEROES
###############################################################################################################################################################
#
path_to_heroes = "../game_data/data/MapObjects"

def hero_doc_line(name, path):
    print(f"Hero {name}")
    with open(path, 'r') as xdb:
        hero = xmltodict.parse(xdb.read())
    desc_path = os.path.join(workdir, root_text_path + hero['AdvMapHeroShared']['SpecializationNameFileRef']['@href'])
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
    desc = re.sub(r'<[^>]+>', '', desc)
    desc = desc.replace('•','-')
    return desc

def generate_heroes_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'HEROES.md'), 'w')
    print("# HEROES DOCUMENTATION", file=out)
    for faction in ref_data.keys():
        print("", file=out)
        print(f"### {faction}:", file=out)
        for h in ref_data[faction]:
            name = h['name']
            path = os.path.join(workdir, path_to_heroes, h['path'])
            hero = hero_doc_line(name, path)
            print("", file=out)
            print("---", file=out)
            print(f"__{name} :__", file=out)
            print(hero, file=out)
    out.close()
#
###############################################################################################################################################################

### SKILLS
###############################################################################################################################################################
#
path_to_skills = "../game_data/data/GameMechanics/RefTables/Skills.xdb"

def skill_doc_line(name, skill):
    print(f"Skill {name}")
    name_path = os.path.join(workdir, root_text_path + skill['obj']['NameFileRef']['Item']['@href'])
    desc_path = os.path.join(workdir, root_text_path + skill['obj']['DescriptionFileRef']['Item']['@href'])
    with open(name_path, 'r', encoding='utf-16') as name_file:
        name = name_file.read()
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
    return f"- __{name}__ : {desc}"

def get_skill_by_id(skills, id):
    id = 'HERO_SKILL_' + id
    for item in skills:
        if item['ID'] == id:
            return item
    print(f"Skill '{id}' not found")
    return None

def generate_skills_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'SKILLS.md'), 'w')
    print("# SKILLS DOCUMENTATION", file=out)
    file_path = os.path.join(workdir, path_to_skills)
    with open(file_path, 'r') as xdb:
        skills = xmltodict.parse(xdb.read())['Table_HeroSkill_SkillID']['objects']['Item']
    for s in ref_data.keys():
        base = get_skill_by_id(skills, s)
        if base != None:
            print("", file=out)
            print(f"### {s}", file=out)
            for p in ref_data[s]['perks']:
                perk = get_skill_by_id(skills, p)
                if perk != None:
                    print(skill_doc_line(p, perk), file=out)
    out.close()
#
###############################################################################################################################################################

### ARTIFACTS
###############################################################################################################################################################
#
path_to_artifacts = "../game_data/data/GameMechanics/RefTables/Artifacts.xdb"
path_to_artfset_texts = "../game_texts/texts-EN/Text/Game/Artfsets"

def artifact_doc_line(name, artifact):
    print(f"Artifact {name}")
    name_path = os.path.join(workdir, root_text_path + artifact['obj']['NameFileRef']['@href'])
    desc_path = os.path.join(workdir, root_text_path + artifact['obj']['DescriptionFileRef']['@href'])
    with open(name_path, 'r', encoding='utf-16') as name_file:
        name = name_file.read()
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
    return f"- __{name}__ :\n{desc}"

def get_artifact_by_id(artifacts, id):
    for item in artifacts:
        if item['ID'] == id:
            return item
    print(f"Artifact '{id}' not found")
    return None

def generate_artifacts_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'ARTIFACTS.md'), 'w')
    print("# ARTIFACTS DOCUMENTATION", file=out)
    file_path = os.path.join(workdir, path_to_artifacts)
    with open(file_path, 'r') as xdb:
        artifacts = xmltodict.parse(xdb.read())['Table_DBArtifact_ArtifactEffect']['objects']['Item']
    for artfset in ref_data.keys():
        if ref_data[artfset]['id'] == 0:
            set_name = "Neutrals"
            set_desc = "The following artifact do not belong in a set."
        else:
            set_texts = os.path.join(workdir, path_to_artfset_texts, str(ref_data[artfset]['id']))
            with open(set_texts + '/Name.txt', 'r', encoding='utf-16') as name_file:
                set_name = name_file.read()
            with open(set_texts + '/Description.txt', 'r', encoding='utf-16') as desc_file:
                set_desc = desc_file.read()
        print("", file=out)
        print(f"### {set_name}", file=out)
        print(f"{set_desc}", file=out)
        print(f"", file=out)
        for a in ref_data[artfset]['pieces']:
            artifact = get_artifact_by_id(artifacts, a)
            if artifact != None:
                print(artifact_doc_line(a, artifact), file=out)
    out.close()
#
###############################################################################################################################################################


with open(reference_file) as ref:
    data = yaml.safe_load(ref)

generate_creature_doc(data['CREATURES'])
generate_heroes_doc(data['HEROES'])
generate_skills_doc(data['SKILLS'])
generate_artifacts_doc(data['ARTIFACTS'])
