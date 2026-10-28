"""Prints the stats of the creatures of game_data/creatures, one table per tier, with a balance score."""

import argparse
import os
import sys
import xmltodict

workdir = os.path.dirname(os.path.abspath(__file__))
creaturestats_path = os.path.join(workdir, "../../game_data/creatures/GameMechanics/Creature/Creatures")

towns = ["Haven", "Inferno", "Necropolis", "Preserve", "Dungeon", "Academy", "Dwarf", "Orcs", "Neutrals"]
mapping = {
    "HP":"Health",
    "Att":"AttackSkill",
    "Def":"DefenceSkill",
    "MinD":"MinDamage",
    "MaxD":"MaxDamage",
    "Speed":"Speed",
    "Init":"Initiative",
    "SP":"SpellPoints",
    "Exp":"Exp",
    "Power":"Power",
    "Growth":"WeeklyGrowth"
}
# "Dmg" is shown as "min-max" and sorted by its average
stat_names = list(mapping) + ["Dmg"]
default_stats = "Power"

ability_mult = {
    "ABILITY_NONE": 0,
    "ABILITY_SHOOTER": 0,
    "ABILITY_NO_MELEE_PENALTY": 0.1,
    "ABILITY_NO_RANGE_PENALTY": 0.3,
    "ABILITY_RANGE_PENALTY": -0.15,
    "ABILITY_NO_ENEMY_RETALIATION": 0.3,
    "ABILITY_UNLIMITED_RETALIATION": 0.2,
    "ABILITY_DOUBLE_ATTACK": 0.6,
    "ABILITY_DOUBLE_SHOT": 0.6,
    "ABILITY_MECHANICAL": 0.3,
    "ABILITY_UNDEAD": 0.3,
    "ABILITY_DEMONIC": 0.1,
    "ABILITY_ELEMENTAL": 0.2,
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
    "ABILITY_SHIELD_OTHER": 0.2,
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
    "ABILITY_CHAIN_SHOT": 0.5,
    "ABILITY_WEAKENING_STRIKE": 0.1,
    "ABILITY_INCORPOREAL": 0.4,
    "ABILITY_MANA_DRAIN": 0.05,
    "ABILITY_LIFE_DRAIN": 0.3,
    "ABILITY_DEATH_CLOUD": 0.2,
    "ABILITY_ELVES_DOUBLE_SHOT": 0.6,
    "ABILITY_WARDING_ARROWS": 0.1,
    "ABILITY_BLINDING_ATTACK": 0.2,
    "ABILITY_AURA_OF_MAGIC_RESISTANCE": 0.2,
    "ABILITY_TAKE_ROOTS": 0.05,
    "ABILITY_ENTANGLING_ROOTS": 0.1,
    "ABILITY_ACID_BREATH": 0.2,
    "ABILITY_MAGIC_ATTACK": 0.2,
    "ABILITY_ENERGY_CHANNEL": 0.1,
    "ABILITY_MAGIC_PROOF_75": 0.25,
    "ABILITY_POISONOUS_ATTACK": 0.2,
    "ABILITY_STRIKE_AND_RETURN": 0.1,
    "ABILITY_BRAVERY": 0.1,
    "ABILITY_RIDER_CHARGE": 0.25,
    "ABILITY_LIZARD_BITE": 0.1,
    "ABILITY_SIX_HEADED_ATTACK": 0.4,
    "ABILITY_REGENERATION": 0.3,
    "ABILITY_WHIP_STRIKE": 0.1,
    "ABILITY_FIRE_SHIELD": 0.2,
    "ABILITY_DEADLY_STRIKE": 0.2,
    "ABILITY_REBIRTH": 0.5,
    "ABILITY_FRIGHTFUL_PRESENCE": 1.0,
    "ABILITY_CRYSTAL_SCALES": 0.1,
    "ABILITY_LARGE_CREATURE": 0,
    "ABILITY_FLYER": 0,
    "ABILITY_CASTER": 0,
    "ABILITY_TAXPAYER": 0.05,
    "ABILITY_SCATTER_SHOT": 0.05,
    "ABILITY_RESURRECT_ALLIES": 0.2,
    "ABILITY_BALOR_SUMMONIG": 0.1,
    "ABILITY_SPRAY_ATTACK": 0.2,
    "ABILITY_MANA_FEED": 0.05,
    "ABILITY_FIRE_BREATH": 0.3,
    "ABILITY_HARM_TOUCH": 0.05,
    "ABILITY_WAR_DANCE": 0.25,
    "ABILITY_REPAIR": 0.1,
    "ABILITY_RANDOM_CASTER": 0.1,
    "ABILITY_DASH": 0.1,
    "ABILITY_CALL_LIGHTNING": 0.15,
    "ABILITY_LAY_HANDS": 0.05,
    "ABILITY_THREE_HEADED_ATTACK": 0.2,
    "ABILITY_ARMORED": 0.1,
    "ABILITY_SHIELD_WALL": 0.25,
    "ABILITY_WOUND": 0.2,
    "ABILITY_PAW_STRIKE": 0.1,
    "ABILITY_BERSERKER_RAGE": 0.1,
    "ABILITY_STORMBOLT": 0.1,
    "ABILITY_STORMSTRIKE": 0.6,
    "ABILITY_MARK_OF_FIRE": 0.05,
    "ABILITY_CROSS_ATTACK": 0.2,
    "ABILITY_MAGMA_SHIELD": 0.35,
    "ABILITY_PACK_HUNTER": 0.1,
    "ABILITY_HOWL": 0.35,
    "ABILITY_AGILITY": 0.1,
    "ABILITY_HEXING_ATTACK": 0.2,
    "ABILITY_CLEAVE": 0.5,
    "ABILITY_BATTLE_FRENZY": 0.05,
    "ABILITY_PACK_DIVE": 0.3,
    "ABILITY_CHAMPION_CHARGE": 0.1,
    "ABILITY_PURGER": 0.05,
    "ABILITY_BLADE_BARRIER": 0,
    "ABILITY_DEMON_RAGED": 0.25,
    "ABILITY_COWARDICE": -0.35,
    "ABILITY_TREACHERY": -0.1,
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
    "ABILITY_CRUSHING_BLOW": 0.3,
    "ABILITY_EVIL_EYE": 0.2,
    "ABILITY_RANDOM_CASTER_BLESS": 0.1,
    "ABILITY_SYPHON_MANA": 0.05,
    "ABILITY_SEARING_AURA": 0.2,
    "ABILITY_AXE_OF_SLAUGHTER": 0.3,
    "ABILITY_SUMMON_OTHER": 0.05,
    "ABILITY_SEDUCE": 0.4,
    "ABILITY_LEAP": 0.25,
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
    "ABILITY_WHIRLWIND": 0.35,
    "ABILITY_ELDRITCH_AURA": 0.1,
    "ABILITY_AURA_OF_FIRE_VULNERABILITY": 0.1,
    "ABILITY_AURA_OF_ICE_VULNERABILITY": 0.1,
    "ABILITY_AURA_OF_LIGHTNING_VULNERABILITY": 0.2,
    "ABILITY_AURA_OF_EARTH_VULNERABILITY": 0.1,
    "ABILITY_CALL_STORM": 0.1,
    "ABILITY_SABOTAGE": 0.1,
    "ABILITY_LUCK_GAMBLER": 0.1,
    "ABILITY_ENCHANTED_OBSIDIAN": 0.2,
    "ABILITY_ACID_BLOOD": 0.2,
    "ABILITY_AURA_OF_BRAVERY": 0.1,
    "ABILITY_INCINERATE": 0.2,
    "ABILITY_INVISIBILITY": 0.2,
    "ABILITY_RIDE_BY_ATTACK": 0.2,
    "ABILITY_ANTI_GIANT": 0.1,
    "ABILITY_AVENGING_FLAME": 0.05,
    "ABILITY_PREPARED_POSITION": 0.05,
    "ABILITY_BATTLE_RAGE": 0.1,
    "ABILITY_HARPOON_STRIKE": 0.05,
    "ABILITY_BEAR_ROAR": 0.2,
    "ABILITY_HOLD_GROUND": 0.05,
    "ABILITY_FLAMEWAVE": 0.1,
    "ABILITY_FLAMESTRIKE": 0.2,
    "ABILITY_LIQUID_FLAME_BREATH": 0.35,
    "ABILITY_IMMUNITY_TO_CURSE": 0.1,
    "ABILITY_IMMUNITY_TO_BERSERK": 0.1,
    "ABILITY_IMMUNITY_TO_HYPNOTIZE": 0.2,
    "ABILITY_MAGIC_PROOF_25": 0.1,
    "ABILITY_FIRE_PROOF_50": 0.1,
    "ABILITY_DESTRUCTION_MAGIC_MAGNETISM": 0.1,
}

def get_stat(creature, stat):
    if stat == "Dmg":
        return (get_stat(creature, "MinD") + get_stat(creature, "MaxD")) / 2
    return int(creature.get(mapping[stat]) or 0)

def format_stat(creature, stat):
    if stat == "Dmg":
        return f"{get_stat(creature, 'MinD')}-{get_stat(creature, 'MaxD')}"
    return str(get_stat(creature, stat))

def get_abilities(creature):
    if not creature.get("Abilities"):
        return []
    abilities = creature["Abilities"]["Item"]
    return [abilities] if isinstance(abilities, str) else abilities

# Score = base x stats x abilities
# - base: the stats that add up with the stack size. A stack's fighting value grows with
#   health x damage (Lanchester's square law), so one creature is worth sqrt(health x damage).
# - stats: the stats whose effect does not depend on the stack size. Attack multiplies the damage
#   dealt and defence divides the damage taken by 1 + 3% per point, initiative multiplies how often
#   the creature acts; as they scale health or damage, they enter the square root like them.
# - abilities: 1 + the sum of the ability_mult weights.
ATTACK_DEFENCE_FACTOR = 0.03
INITIATIVE_REFERENCE = 10
INIT_EXPONENT = 0.5
SPEED_REFERENCE = 6
SPEED_EXPONENT = 0.5
FLYING_MULT = 1.1
RANGED_MULT = 1.3
CASTER_MULT = 1.2

def get_base_score(creature):
    # return int(10 * ((get_stat(creature, "HP") * get_stat(creature, "Dmg")) ** 0.5))
    return 4 * (get_stat(creature, "HP") ** 0.8) + 2 * get_stat(creature, "MinD") + 2 * get_stat(creature, "MaxD") + get_stat(creature, "SP") + (get_stat(creature, "Growth") ** 0.8)

def get_stats_mult(creature):
    offence = 1 + ATTACK_DEFENCE_FACTOR * get_stat(creature, "Att")
    defence = 1 + ATTACK_DEFENCE_FACTOR * get_stat(creature, "Def")
    mult = (offence * defence) ** 0.5
    mult *= (get_stat(creature, "Init") / INITIATIVE_REFERENCE) ** INIT_EXPONENT
    mult *= (get_stat(creature, "Speed") / SPEED_REFERENCE) ** SPEED_EXPONENT
    if creature["Flying"] == "true":
        mult *= FLYING_MULT
    if int(creature["Range"]) != 0:
        mult *= RANGED_MULT
    if int(creature["SpellPoints"]) != 0:
        mult *= CASTER_MULT
    return mult

def get_abilities_mult(creature):
    return 1 + sum(ability_mult.get(ability, 0) for ability in get_abilities(creature))

def get_creature_score(creature):
    creature["base"] = get_base_score(creature)
    creature["stats_mult"] = get_stats_mult(creature)
    creature["abilities_mult"] = get_abilities_mult(creature)
    return creature["base"] * (creature["stats_mult"] * creature["abilities_mult"]) ** 0.5

def load_creatures(towns):
    creatures = []
    for town in towns:
        for path, subdirs, files in os.walk(os.path.join(creaturestats_path, town)):
            for file in files:
                if file.endswith('.xdb'):
                    with open(os.path.join(path, file), 'r', encoding="utf-8") as f:
                        creature_data = xmltodict.parse(f.read())
                    if "Creature" in creature_data:
                        creature_data = creature_data["Creature"]
                        creature_data["name"] = file[:-len(".xdb")].replace('_', ' ')
                        creature_data["town"] = os.path.relpath(path, creaturestats_path).replace('\\', '/')
                        creature_data["score"] = get_creature_score(creature_data)
                        creatures.append(creature_data)
    return creatures

def parse_args(towns):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-t", "--tier", type=int, nargs="+", metavar="N", help="tiers to print (default: all)")
    parser.add_argument("--town", nargs="+", metavar="TOWN", help=f"towns to print (default: all), among {', '.join(towns)}")
    parser.add_argument("-s", "--stats", default=default_stats, help=f"comma-separated stat columns, among {','.join(stat_names)} (default: {default_stats})")
    parser.add_argument("--sort", default="score", help="sort column: score, name, town or a stat (default: score)")
    parser.add_argument("-r", "--reverse", action="store_true", help="reverse the sort order")
    parser.add_argument("-a", "--abilities", action="store_true", help="list the abilities of each creature with their score weight")
    parser.add_argument("--no-color", action="store_true", help="plain output (also when NO_COLOR is set or the output is not a terminal)")
    args = parser.parse_args()

    def pick(value, choices, what):
        match = next((c for c in choices if c.lower() == value.lower()), None)
        if match is None:
            parser.error(f"unknown {what} '{value}', expected one of {', '.join(choices)}")
        return match

    args.town = [pick(t, towns, "town") for t in args.town] if args.town else towns
    args.stats = [pick(s.strip(), stat_names, "stat") for s in args.stats.split(',') if s.strip()]
    args.sort = pick(args.sort, ["score", "name", "town"] + stat_names, "sort column")
    return args

class Style:
    def __init__(self, enabled):
        self.enabled = enabled
        if enabled and os.name == "nt":
            os.system("")  # enables ANSI escape codes in the Windows console

    def __call__(self, text, *codes):
        return f"\033[{';'.join(codes)}m{text}\033[0m" if self.enabled and codes else text

BOLD, DIM, UNDERLINE, CYAN, GREEN, YELLOW = "1", "2", "4", "36", "32", "33"
BAR_WIDTH = 16

def ability_label(ability):
    return ability.removeprefix("ABILITY_").replace('_', ' ').capitalize()

def print_tier(tier, creatures, args, style):
    # (header, cell text, right-aligned)
    columns = [("Creature", lambda c: c["name"], False), ("Town", lambda c: c["town"], False)]
    columns += [(stat, lambda c, stat=stat: format_stat(c, stat), True) for stat in args.stats]
    columns += [
        ("Base", lambda c: f"{c['base']:.1f}", True),
        ("×Stats", lambda c: f"{c['stats_mult']:.2f}", True),
        ("×Abil", lambda c: f"{c['abilities_mult']:.2f}", True),
        ("Score", lambda c: f"{c['score']:.1f}", True),
    ]
    rows = [[cell(c) for _, cell, _ in columns] for c in creatures]
    widths = [max([len(header)] + [len(row[i]) for row in rows]) for i, (header, _, _) in enumerate(columns)]
    best = max(c["score"] for c in creatures) or 1

    def line(cells, styles):
        out = []
        for i, (text, (_, _, right)) in enumerate(zip(cells, columns)):
            padded = text.rjust(widths[i]) if right else text.ljust(widths[i])
            out.append(style(padded, *styles[i]))
        return "  ".join(out)

    title = f"Tier {tier}"
    print(style(title, BOLD, CYAN) + style(f"  {len(creatures)} creature{'s' if len(creatures) > 1 else ''}", DIM))
    header_styles = [(BOLD, UNDERLINE) if header.lower() == args.sort.lower() else (BOLD,) for header, _, _ in columns]
    print(line([header for header, _, _ in columns], header_styles))
    print(style("─" * (sum(widths) + 2 * (len(widths) - 1) + 2 + BAR_WIDTH), DIM))
    for creature, row in zip(creatures, rows):
        filled = round(BAR_WIDTH * max(creature["score"], 0) / best)
        bar = style("█" * filled, GREEN) + style("░" * (BAR_WIDTH - filled), DIM)
        cell_styles = [(BOLD,), (DIM,)] + [()] * len(args.stats) + [(DIM,)] * 3 + [(YELLOW,)]
        print(line(row, cell_styles) + "  " + bar)
        if args.abilities:
            abilities = [f"{ability_label(a)} {ability_mult[a]:+g}" if a in ability_mult else f"{ability_label(a)} ?" for a in get_abilities(creature)]
            if abilities:
                print(style("    " + " · ".join(abilities), DIM))
    print()

def main():
    # Box-drawing characters fail in the default Windows code page when the output is redirected
    sys.stdout.reconfigure(encoding="utf-8")
    args = parse_args(towns)
    style = Style(not args.no_color and sys.stdout.isatty() and "NO_COLOR" not in os.environ)
    creatures = load_creatures(args.town)

    if args.sort in ("name", "town"):
        sort_key, descending = (lambda c: (c[args.sort].lower(), c["name"].lower())), False
    elif args.sort == "score":
        sort_key, descending = (lambda c: c["score"]), True
    else:
        sort_key, descending = (lambda c: get_stat(c, args.sort)), True
    creatures.sort(key=sort_key, reverse=descending != args.reverse)

    tiers = sorted({int(c["CreatureTier"]) for c in creatures})
    for tier in args.tier or tiers:
        tier_creatures = [c for c in creatures if int(c["CreatureTier"]) == tier]
        if tier_creatures:
            print_tier(tier, tier_creatures, args, style)

main()
