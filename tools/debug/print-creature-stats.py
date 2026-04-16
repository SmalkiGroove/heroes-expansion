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

ability_mult = {
    "ABILITY_NONE": 0,
    "ABILITY_SHOOTER": 0.3,
    "ABILITY_NO_MELEE_PENALTY": 0.1,
    "ABILITY_NO_RANGE_PENALTY": 0.3,
    "ABILITY_RANGE_PENALTY": -0.3,
    "ABILITY_NO_ENEMY_RETALIATION": 0.3,
    "ABILITY_UNLIMITED_RETALIATION": 0.2,
    "ABILITY_DOUBLE_ATTACK": 0.5,
    "ABILITY_DOUBLE_SHOT": 0.5,
    "ABILITY_MECHANICAL": 0.3,
    "ABILITY_UNDEAD": 0.3,
    "ABILITY_DEMONIC": 0.1,
    "ABILITY_ELEMENTAL": 0.3,
    "ABILITY_CURSING_ATTACK": 0.1,
    "ABILITY_FLESH_AND_BLOOD": 0,
    "ABILITY_ENRAGED": 0.1,
    "ABILITY_IMMUNITY_TO_BLIND": 0.1,
    "ABILITY_IMMUNITY_TO_MAGIC": 0.5,
    "ABILITY_IMMUNITY_TO_SLOW": 0.1,
    "ABILITY_IMMUNITY_TO_MIND_CONTROL": 0.4,
    "ABILITY_IMMUNITY_TO_AIR": 0.2,
    "ABILITY_IMMUNITY_TO_FIRE": 0.2,
    "ABILITY_IMMUNITY_TO_WATER": 0.2,
    "ABILITY_IMMUNITY_TO_EARTH": 0.2,
    "ABILITY_MAGIC_PROOF_50": 0.2,
    "ABILITY_PRECISE_SHOT": 0.1,
    "ABILITY_LARGE_SHIELD": 0.2,
    "ABILITY_SHIELD_OTHER": 0.3,
    "ABILITY_JOUSTING": 0.2,
    "ABILITY_BASH": 0.2,
    "ABILITY_BATTLE_DIVE": 0.2,
    "ABILITY_MANA_DESTROYER": 0.05,
    "ABILITY_MANA_STEALER": 0.05,
    "ABILITY_EXPLOSION": 0.05,
    "ABILITY_RANGED_RETALIATE": 0.1,
    "ABILITY_FEAR": 0.2,
    "ABILITY_FRIGHT_AURA": 0.1,
    "ABILITY_VORPAL_SWORD": 0.1,
    "ABILITY_CHAIN_SHOT": 0.4,
    "ABILITY_WEAKENING_STRIKE": 0.1,
    "ABILITY_INCORPOREAL": 0.3,
    "ABILITY_MANA_DRAIN": 0.05,
    "ABILITY_LIFE_DRAIN": 0.3,
    "ABILITY_DEATH_CLOUD": 0.2,
    "ABILITY_ELVES_DOUBLE_SHOT": 0.5,
    "ABILITY_WARDING_ARROWS": 0.1,
    "ABILITY_BLINDING_ATTACK": 0.2,
    "ABILITY_AURA_OF_MAGIC_RESISTANCE": 0.2,
    "ABILITY_TAKE_ROOTS": 0.05,
    "ABILITY_ENTANGLING_ROOTS": 0.1,
    "ABILITY_ACID_BREATH": 0.2,
    "ABILITY_MAGIC_ATTACK": 0.2,
    "ABILITY_ENERGY_CHANNEL": 0.1,
    "ABILITY_MAGIC_PROOF_75": 0.2,
    "ABILITY_POISONOUS_ATTACK": 0.2,
    "ABILITY_STRIKE_AND_RETURN": 0.2,
    "ABILITY_BRAVERY": 0.1,
    "ABILITY_RIDER_CHARGE": 0.3,
    "ABILITY_LIZARD_BITE": 0.1,
    "ABILITY_SIX_HEADED_ATTACK": 0.4,
    "ABILITY_REGENERATION": 0.3,
    "ABILITY_WHIP_STRIKE": 0.1,
    "ABILITY_FIRE_SHIELD": 0.2,
    "ABILITY_DEADLY_STRIKE": 0.2,
    "ABILITY_REBIRTH": 0.5,
    "ABILITY_FRIGHTFUL_PRESENCE": 0.99,
    "ABILITY_CRYSTAL_SCALES": 0.1,
    "ABILITY_LARGE_CREATURE": 0,
    "ABILITY_FLYER": 0.1,
    "ABILITY_CASTER": 0.1,
    "ABILITY_TAXPAYER": 0.05,
    "ABILITY_SCATTER_SHOT": 0.05,
    "ABILITY_RESURRECT_ALLIES": 0.2,
    "ABILITY_BALOR_SUMMONIG": 0.1,
    "ABILITY_SPRAY_ATTACK": 0.2,
    "ABILITY_MANA_FEED": 0.05,
    "ABILITY_FIRE_BREATH": 0.3,
    "ABILITY_HARM_TOUCH": 0.05,
    "ABILITY_WAR_DANCE": 0.3,
    "ABILITY_REPAIR": 0.1,
    "ABILITY_RANDOM_CASTER": 0.1,
    "ABILITY_DASH": 0.1,
    "ABILITY_CALL_LIGHTNING": 0.2,
    "ABILITY_LAY_HANDS": 0.05,
    "ABILITY_THREE_HEADED_ATTACK": 0.2,
    "ABILITY_ARMORED": 0.05,
    "ABILITY_SHIELD_WALL": 0.3,
    "ABILITY_WOUND": 0.2,
    "ABILITY_PAW_STRIKE": 0.1,
    "ABILITY_BERSERKER_RAGE": 0.1,
    "ABILITY_STORMBOLT": 0.1,
    "ABILITY_STORMSTRIKE": 0.5,
    "ABILITY_MARK_OF_FIRE": 0.05,
    "ABILITY_CROSS_ATTACK": 0.2,
    "ABILITY_MAGMA_SHIELD": 0.4,
    "ABILITY_PACK_HUNTER": 0.1,
    "ABILITY_HOWL": 0.4,
    "ABILITY_AGILITY": 0.2,
    "ABILITY_HEXING_ATTACK": 0.3,
    "ABILITY_CLEAVE": 0.4,
    "ABILITY_BATTLE_FRENZY": 0.05,
    "ABILITY_PACK_DIVE": 0.3,
    "ABILITY_CHAMPION_CHARGE": 0.1,
    "ABILITY_PURGER": 0.05,
    "ABILITY_BLADE_BARRIER": 0,
    "ABILITY_DEMON_RAGED": 0.2,
    "ABILITY_COWARDICE": -0.4,
    "ABILITY_TREACHERY": -0.2,
    "ABILITY_SET_SNARES": 0.1,
    "ABILITY_DEFILE_MAGIC": 0.1,
    "ABILITY_MANEURE": 0.1,
    "ABILITY_BRUTALITY": 0.2,
    "ABILITY_TAUNT": 0.2,
    "ABILITY_FIERCE_RETALIATION": 0.1,
    "ABILITY_SACRIFICE_GOBLIN": 0.05,
    "ABILITY_FAST_ATTACK": 0.1,
    "ABILITY_PRESENCE_OF_COMMANDER": 0.1,
    "ABILITY_ORDER_OF_THE_CHIEF": 0.1,
    "ABILITY_VENOM": 0.2,
    "ABILITY_SCAVENGER": 0.2,
    "ABILITY_LIGHTNING_BREATH": 0.2,
    "ABILITY_SWALLOW_GOBLIN": 0,
    "ABILITY_GOBLIN_THROWER": 0.2,
    "ABILITY_CRUSHING_BLOW": 0.2,
    "ABILITY_EVIL_EYE": 0.2,
    "ABILITY_RANDOM_CASTER_BLESS": 0.1,
    "ABILITY_SYPHON_MANA": 0.05,
    "ABILITY_SEARING_AURA": 0.2,
    "ABILITY_AXE_OF_SLAUGHTER": 0.3,
    "ABILITY_SUMMON_OTHER": 0.05,
    "ABILITY_SEDUCE": 0.4,
    "ABILITY_LEAP": 0.3,
    "ABILITY_DEATH_WAIL": 0.2,
    "ABILITY_WEAKENING_AURA": 0.1,
    "ABILITY_AMMO_STEAL": 0.05,
    "ABILITY_SLEEPING_STRIKE": 0.3,
    "ABILITY_SORROW_STRIKE": 0.1,
    "ABILITY_HORROR_OF_THE_DEATH": 0.2,
    "ABILITY_PIERCING_ARROW": 0.3,
    "ABILITY_TREEANT_UNION": 0.1,
    "ABILITY_RAGE_OF_THE_FOREST": 0.2,
    "ABILITY_POWER_FEED": 0.1,
    "ABILITY_RAINBOW_BREATH": 0.1,
    "ABILITY_BOND_OF_LIGHT": 0.3,
    "ABILITY_WHIRLWIND": 0.4,
    "ABILITY_ELDRITCH_AURA": 0.1,
    "ABILITY_AURA_OF_FIRE_VULNERABILITY": 0.1,
    "ABILITY_AURA_OF_ICE_VULNERABILITY": 0.1,
    "ABILITY_AURA_OF_LIGHTNING_VULNERABILITY": 0.1,
    "ABILITY_AURA_OF_EARTH_VULNERABILITY": 0.1,
    "ABILITY_CALL_STORM": 0.2,
    "ABILITY_SABOTAGE": 0.1,
    "ABILITY_LUCK_GAMBLER": 0.1,
    "ABILITY_ENCHANTED_OBSIDIAN": 0.2,
    "ABILITY_ACID_BLOOD": 0.2,
    "ABILITY_AURA_OF_BRAVERY": 0.1,
    "ABILITY_INCINERATE": 0.2,
    "ABILITY_INVISIBILITY": 0.3,
    "ABILITY_RIDE_BY_ATTACK": 0.2,
    "ABILITY_ANTI_GIANT": 0.1,
    "ABILITY_AVENGING_FLAME": 0.05,
    "ABILITY_PREPARED_POSITION": 0.05,
    "ABILITY_BATTLE_RAGE": 0.1,
    "ABILITY_HARPOON_STRIKE": 0.05,
    "ABILITY_BEAR_ROAR": 0.2,
    "ABILITY_HOLD_GROUND": 0.05,
    "ABILITY_FLAMEWAVE": 0.1,
    "ABILITY_FLAMESTRIKE": 0.3,
    "ABILITY_LIQUID_FLAME_BREATH": 0.4,
    "ABILITY_IMMUNITY_TO_CURSE": 0.1,
    "ABILITY_IMMUNITY_TO_BERSERK": 0.1,
    "ABILITY_IMMUNITY_TO_HYPNOTIZE": 0.2,
    "ABILITY_MAGIC_PROOF_25": 0.1,
    "ABILITY_FIRE_PROOF_50": 0.2,
    "ABILITY_DESTRUCTION_MAGIC_MAGNETISM": 0.1,
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

    mult = 1
    if creature["Flying"] == "true":
        mult += 0.1
    if int(creature["Range"]) != 0:
        mult += 0.3
    if creature["Abilities"] is not None:
        abilities = creature["Abilities"]["Item"]
        if isinstance(abilities, dict):
            abilities = [abilities]
        for ability in abilities:
            mult += ability_mult.get(ability, 1)
    
    score *= mult
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
