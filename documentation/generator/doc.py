import os
import re
import yaml
import xmltodict

# MARKDOWN TEXT GENERATOR FOR README
# USAGE : python doc.py ...

workdir = os.path.dirname(os.path.abspath(__file__))
reference_file = os.path.join(workdir, "doc-refs.yml")
doc_path = ".."

root_core_path = "../../game_data/core"
root_creatures_path = "../../game_data/creatures"
root_heroes_path = "../../game_data/heroes"
root_spells_path = "../../game_data/spells"
root_skills_path = "../../game_data/skills"
root_artifacts_path = "../../game_data/artifacts"
root_text_path = "../../game_texts/texts-EN"

### CREATURES
###############################################################################################################################################################
#

def is_valid_spell(id):
    if id.startswith("SPELL_RUNE_OF_"):
        return False
    return True

def get_spell_name(id):
    with open(os.path.join(workdir, root_spells_path, "GameMechanics/RefTables/UndividedSpells.xdb"), 'r') as xdb:
        allspells = xmltodict.parse(xdb.read())
    for item in allspells['Table_Spell_SpellID']['objects']['Item']:
        if item['ID'] == id:
            spell_path = os.path.join(workdir, root_spells_path + item['Obj']['@href'].replace('#xpointer(/Spell)',''))
            with open(spell_path, 'r', encoding='utf-8-sig') as spell_file:
                spl = xmltodict.parse(spell_file.read())
            name_path = os.path.join(workdir, root_text_path + spl['Spell']['NameFileRef']['@href'])
            with open(name_path, 'r', encoding='utf-16') as name_file:
                return name_file.read()
    print(f"Spell '{id}' not found")
    return id

def get_spells_text(spells):
    if isinstance(spells, list):
        return ', '.join([f"{get_spell_name(spell['Spell'])} ({spell['Mastery'].replace('MASTERY_','').lower()})" for spell in spells if is_valid_spell(spell['Spell'])])
    else:
        return f"{get_spell_name(spells['Spell'])} ({spells['Mastery'].replace('MASTERY_','').lower()})"

def get_ability_name(id):
    with open(os.path.join(workdir, root_creatures_path, "GameMechanics/RefTables/CombatAbilities.xdb"), 'r') as xdb:
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
            path = os.path.join(workdir, root_creatures_path, "GameMechanics/Creature/Creatures", c['path'])
            line = creature_doc_line(tier, upg, name, path)
            print(line, file=out)
    out.close()
#
###############################################################################################################################################################

### HEROES
###############################################################################################################################################################
#

def hero_doc_line(name, path):
    print(f"Hero {name}")
    with open(path, 'r') as xdb:
        hero = xmltodict.parse(xdb.read())
    desc_path = os.path.join(workdir, root_text_path + hero['AdvMapHeroShared']['SpecializationDescFileRef']['@href'])
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
            path = os.path.join(workdir, root_heroes_path, "MapObjects", h['path'])
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

def skill_doc_line(name, skill):
    print(f"Skill {name}")
    if name == "NONE":
        return "Ultimate skills"
    skill_type = skill['obj']['SkillType']
    if skill_type == "SKILLTYPE_SKILL":
        name_path = os.path.join(workdir, root_text_path + skill['obj']['CommonNameFileRef']['@href'])
        desc_path = os.path.join(workdir, root_text_path + skill['obj']['CommonDescriptionFileRef']['@href'])
    else:
        name_path = os.path.join(workdir, root_text_path + skill['obj']['NameFileRef']['Item']['@href'])
        desc_path = os.path.join(workdir, root_text_path + skill['obj']['DescriptionFileRef']['Item']['@href'])
    with open(name_path, 'r', encoding='utf-16') as name_file:
        name = name_file.read()
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
    if skill_type == "SKILLTYPE_SKILL":
        return f"### {name}\n{desc}"
    else:
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
    file_path = os.path.join(workdir, root_skills_path, "GameMechanics/RefTables/Skills.xdb")
    with open(file_path, 'r') as xdb:
        skills = xmltodict.parse(xdb.read())['Table_HeroSkill_SkillID']['objects']['Item']
    for s in ref_data.keys():
        base = get_skill_by_id(skills, s)
        if base != None:
            print("", file=out)
            print(skill_doc_line(s, base), file=out)
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

def artifact_doc_line(name, artifact):
    print(f"Artifact {name}")
    name_path = os.path.join(workdir, root_text_path + artifact['obj']['NameFileRef']['@href'])
    desc_path = os.path.join(workdir, root_text_path + artifact['obj']['DescriptionFileRef']['@href'])
    with open(name_path, 'r', encoding='utf-16') as name_file:
        name = name_file.read()
    with open(desc_path, 'r', encoding='utf-16') as desc_file:
        desc = desc_file.read()
        desc = re.sub(r'<color=FFB730FF>[A-Za-z\' ]*', '', desc)
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
    file_path = os.path.join(workdir, root_artifacts_path, "GameMechanics/RefTables/Artifacts.xdb")
    with open(file_path, 'r') as xdb:
        artifacts = xmltodict.parse(xdb.read())['Table_DBArtifact_ArtifactEffect']['objects']['Item']
    for artfset in ref_data.keys():
        if ref_data[artfset]['id'] == 0:
            set_name = "Neutrals"
            set_desc = "The following artifact do not belong in a set."
        else:
            set_texts = os.path.join(workdir, root_text_path, "Text/Game/Artfsets", str(ref_data[artfset]['id']))
            with open(set_texts + '/Name.txt', 'r', encoding='utf-16') as name_file:
                set_name = name_file.read()
            with open(set_texts + '/Description.txt', 'r', encoding='utf-16') as desc_file:
                set_desc = desc_file.read()
                set_desc = re.sub(r'<[^>]+>', '', set_desc)
        print("", file=out)
        print("---", file=out)
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

### SPELLS
###############################################################################################################################################################
#
spells_by_school = {'LIGHT': [], 'DARK': [], 'DESTRUCTIVE': [], 'NATURAL': [], 'WARCRY': []}
spells_by_tier = {1: [], 2: [], 3: [], 4: [], 5: []}
spells_school_mapping = {
    'MAGIC_SCHOOL_LIGHT': 'Light Magic',
    'MAGIC_SCHOOL_DARK': 'Dark Magic',
    'MAGIC_SCHOOL_DESTRUCTIVE': 'Destructive Magic',
    'MAGIC_SCHOOL_SUMMONING': 'Natural Magic',
    'MAGIC_SCHOOL_WARCRIES': 'Warcries'
}

def get_spell_by_id(id, allspells):
    print(f"Get spell {id} data")
    for item in allspells:
        if item['ID'] == id:
            spell_path = os.path.join(workdir, root_spells_path + item['Obj']['@href']).replace('#xpointer(/Spell)','')
            with open(spell_path, 'r') as xdb:
                spell_data = xmltodict.parse(xdb.read())['Spell']
            return spell_data
    print(f"Spell '{id}' not found")
    return None

def get_spell_name_2(id, allspells):
    spell = get_spell_by_id(id, allspells)
    if spell != None:
        name_path = os.path.join(workdir, root_text_path + spell['NameFileRef']['@href'])
        with open(name_path, 'r', encoding='utf-16') as name_file:
            name = name_file.read()
        return name
    return ""

def get_spell_link(name):
    return f"[{name}](#{name.lower().replace(' ', '-')})"

def spells_doc_line(tier, allspells):
    number = min(tier, 3)
    s_light = list(map(lambda s: get_spell_name_2(s, allspells), set(spells_by_tier[tier]).intersection(spells_by_school['LIGHT'])))
    s_dark = list(map(lambda s: get_spell_name_2(s, allspells), set(spells_by_tier[tier]).intersection(spells_by_school['DARK'])))
    s_destructive = list(map(lambda s: get_spell_name_2(s, allspells), set(spells_by_tier[tier]).intersection(spells_by_school['DESTRUCTIVE'])))
    s_natural = list(map(lambda s: get_spell_name_2(s, allspells), set(spells_by_tier[tier]).intersection(spells_by_school['NATURAL'])))
    line = "| | | | | |"
    for i in range(number):
        line = f"| {tier} | {get_spell_link(s_light[i])} | {get_spell_link(s_dark[i])} | {get_spell_link(s_destructive[i])} | {get_spell_link(s_natural[i])} |\n" + line
    return line

def spell_doc_line(id, allspells):
    spell_data = get_spell_by_id(id, allspells)
    if spell_data != None:
        name_path = os.path.join(workdir, root_text_path + spell_data['NameFileRef']['@href'])
        desc_path = os.path.join(workdir, root_text_path + spell_data['LongDescriptionFileRef']['@href'])
        with open(name_path, 'r', encoding='utf-16') as name_file:
            name = name_file.read()
        with open(desc_path, 'r', encoding='utf-16') as desc_file:
            desc = desc_file.read()
        tier = spell_data['Level']
        school = spell_data['MagicSchool']
        mana = spell_data['TrainedCost']
        damage = yaml.dump(spell_data['damage']['Item']) if spell_data['damage'] is not None else "N/A"
        duration = yaml.dump(spell_data['duration']['Item']) if spell_data['duration'] is not None else "N/A"
        return f"\n#### {name}\n>Tier {tier} {spells_school_mapping[school]}  ({mana} Mana)\n\n{desc}\n\nDamage :\n{damage}\nDuration :\n{duration}"
    return ""
        
def generate_spells_doc(ref_data):
    out = open(os.path.join(workdir, doc_path, 'SPELLS.md'), 'w')
    print("# SPELLS DOCUMENTATION", file=out)
    print("", file=out)
    for spell in ref_data:
        spells_by_school[spell['school']].append(spell['id'])
        spells_by_tier[spell['tier']].append(spell['id'])
    with open(os.path.join(workdir, root_spells_path, "GameMechanics/RefTables/UndividedSpells.xdb"), 'r') as xdb:
        allspells = xmltodict.parse(xdb.read())['Table_Spell_SpellID']['objects']['Item']
    print("## Classification", file=out)
    print("| Tier | LIGHT | DARK | DESTRUCTIVE | NATURAL |", file=out)
    print("|------|-------|------|-------------|---------|", file=out)
    for tier in range(1,6):
        print(spells_doc_line(tier, allspells), file=out)
    print("\n", file=out)
    print("## Spells data", file=out)
    for spell in ref_data:
        print(spell_doc_line(spell['id'], allspells), file=out)
    out.close()
#
###############################################################################################################################################################

with open(reference_file) as ref:
    data = yaml.safe_load(ref)

generate_creature_doc(data['CREATURES'])
generate_heroes_doc(data['HEROES'])
generate_skills_doc(data['SKILLS'])
generate_artifacts_doc(data['ARTIFACTS'])
generate_spells_doc(data['SPELLS'])
