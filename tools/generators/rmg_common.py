"""Shared definitions of the random map generator (RMG) template tools.

A template source is a YAML file of tools/generators/rmg-templates/. generate-rmg-templates.py turns each
one into game_data/maps/RMG/Templates/<file name>.xdb, and import-rmg-templates.py does the reverse.
The format is described in .cursor/rules/rmg.md.
"""

import os

import yaml

from common import GAME_DATA, GENERATORS_DIR, TEXTS_EN

SOURCES_DIR = os.path.join(GENERATORS_DIR, "rmg-templates")
SHARED_PROFILES = "_profiles.yml"
TEMPLATES_DIR = os.path.join(GAME_DATA, "maps", "RMG", "Templates")
# NameFileRef / DescriptionFileRef are relative to the template, so its texts live in /RMG/Templates/
TEXTS_DIR = os.path.join(TEXTS_EN, "RMG", "Templates")

# Order of the 7 <Mines> items
RESOURCES = ("wood", "ore", "mercury", "crystal", "sulfur", "gem", "gold")
# <Dwellings> item i is the number of dwellings of creature tier i + 1 (the exe has 7 random dwellings)
MAX_DWELLING_TIERS = 7
# <Setting> values; the first three mean a random faction
SETTINGS = ("RACE_SPECIAL", "RACE_RANDOM_TYPE", "RACE_NO_TYPE", "RACE_HEAVEN", "RACE_PRESERVE", "RACE_ACADEMY",
            "RACE_DUNGEON", "RACE_NECROMANCY", "RACE_INFERNO", "RACE_DWARF", "RACE_STRONGHOLD")
# Map sides of the RMG screen and their area units, the unit of MinMapSize / MaxMapSize
MAP_SIZES = ((72, 5), (96, 10), (136, 18), (176, 31), (216, 47), (256, 66), (320, 102))
# Guard power of one point of GuardStrenght (BasicLeverGuardPower x ConnectionGuardLevel of Params/Default.xdb)
# and of TownGuardStrenght (BasicLeverGuardPower), before the monster level factor of the RMG screen
CONNECTION_GUARD_POWER = 2000
TOWN_GUARD_POWER = 1000

# Zone fields, in XDB order: (YAML key, XDB tag, kind, default). Every zone starts from the defaults.
ZONE_FIELDS = (
    ("setting", "Setting", "str", "RACE_RANDOM_TYPE"),
    ("water", "CanBeWater", "bool", False),
    ("size", "Size", "int", 10),
    ("start", "CanBePlayerStart", "bool", False),
    ("town", "Town", "bool", False),
    ("town_guard", "TownGuardStrenght", "int", 1),
    ("mines", "Mines", "mines", (0,) * len(RESOURCES)),
    ("abandoned_mines", "AbandonedMines", "int", 0),
    ("dwellings", "Dwellings", "list", ()),
    ("upgrades", "UpgBuildingsDensity", "int", 0),
    ("treasures", "TreasureDensity", "int", 0),
    ("chests", "TreasureChestDensity", "int", 0),
    ("prisons", "Prisons", "int", 0),
    ("cartographer", "LandCartographer", "int", 0),
    ("shops", "ShopPoints", "int", 0),
    ("shrines", "ShrinePoints", "int", 0),
    ("luck_morale", "LuckMoralBuildingsDensity", "int", 0),
    ("resource_buildings", "ResourceBuildingsDensity", "int", 0),
    ("treasure_buildings", "TreasureBuildingPoints", "int", 0),
    ("treasure_blocks", "TreasureBlocksTotalValue", "int", 0),
    ("den_of_thieves", "DenOfThieves", "int", 0),
    ("observatories", "RedwoodObservatoryDensity", "int", 0),
    ("buffs", "BuffPoints", "int", 0),
)
ZONE_KEYS = {key for key, _, _, _ in ZONE_FIELDS}
ZONE_DEFAULTS = {key: default for key, _, _, default in ZONE_FIELDS}

# Connection fields: (YAML key, XDB tag, default). from / to (the zone indexes) come first. The RMG never
# reads TwoWay, Guarded and Wide: they are kept so that imported templates are rebuilt as they were.
CONNECTION_FIELDS = (
    ("two_way", "TwoWay", True),
    ("guard", "GuardStrenght", 0),
    ("guarded", "Guarded", True),
    ("wide", "Wide", False),
)
CONNECTION_DEFAULTS = {key: default for key, _, default in CONNECTION_FIELDS}

# Template fields: (YAML key, default). None: computed from the file name.
ROOT_DEFAULTS = {
    "name_file": None,        # NameFileRef, "<file name>.txt"
    "description_file": "",   # DescriptionFileRef
    "players": [2, 2],        # MinPlayers, MaxPlayers
    "map_size": [5, 14],      # MinMapSize, MaxMapSize
    "underground": False,
    "grail": False,           # GraalOnMap
    "test": False,            # TestTemplate: hidden from the template list
}
ROOT_KEYS = set(ROOT_DEFAULTS) | {"title", "description", "profiles", "per_player", "zones", "connections", "teams"}


class TemplateError(Exception):
    pass


def mines_list(value, where):
    """The 7 mine counts, from a list of 7 or a {resource: count} mapping."""
    if isinstance(value, dict):
        unknown = set(value) - set(RESOURCES)
        if unknown:
            raise TemplateError(f"{where}: unknown resource {', '.join(sorted(unknown))} (expected {', '.join(RESOURCES)})")
        return tuple(int(value.get(res, 0)) for res in RESOURCES)
    if isinstance(value, (list, tuple)) and len(value) == len(RESOURCES):
        return tuple(int(v) for v in value)
    raise TemplateError(f"{where}: mines must be a list of {len(RESOURCES)} counts or a {{resource: count}} mapping")


def check_keys(entry, allowed, where):
    unknown = set(entry) - allowed
    if unknown:
        raise TemplateError(f"{where}: unknown key {', '.join(sorted(unknown))}")


def resolve_profile(name, profiles, where, seen=()):
    """Fields of a profile, merged over the profiles it extends (its own `profile` key)."""
    if name not in profiles:
        raise TemplateError(f"{where}: unknown profile '{name}'")
    if name in seen:
        raise TemplateError(f"{where}: profile '{name}' extends itself")
    profile = profiles[name] or {}
    check_keys(profile, ZONE_KEYS | {"profile"}, f"profile '{name}'")
    fields = {}
    for parent in as_names(profile.get("profile")):
        fields.update(resolve_profile(parent, profiles, f"profile '{name}'", seen + (name,)))
    fields.update({k: v for k, v in profile.items() if k != "profile"})
    return fields


def as_names(value):
    if value is None:
        return []
    return value if isinstance(value, list) else [value]


def build_zone(entry, profiles, where):
    """Full field set of a zone: the defaults, then its profiles in order, then its own fields."""
    check_keys(entry, ZONE_KEYS | {"id", "profile"}, where)
    fields = dict(ZONE_DEFAULTS)
    for name in as_names(entry.get("profile")):
        fields.update(resolve_profile(name, profiles, where))
    fields.update({k: v for k, v in entry.items() if k not in ("id", "profile")})
    zone = {}
    for key, _, kind, _ in ZONE_FIELDS:
        value = fields[key]
        if kind == "mines":
            value = mines_list(value, where)
        elif kind == "list":
            value = tuple(int(v) for v in (value or ()))
            if len(value) > MAX_DWELLING_TIERS:
                raise TemplateError(f"{where}: {key} has more than {MAX_DWELLING_TIERS} tiers")
        elif kind == "bool":
            if not isinstance(value, bool):
                raise TemplateError(f"{where}: {key} must be true or false")
        elif kind == "int":
            value = int(value)
        zone[key] = value
    return zone


def load_shared_profiles(sources_dir=SOURCES_DIR):
    path = os.path.join(sources_dir, SHARED_PROFILES)
    if not os.path.isfile(path):
        return {}
    with open(path, encoding="utf-8") as file:
        return yaml.safe_load(file) or {}


def load_template(path, shared_profiles):
    """Reads a template source and expands it: profiles, per-player zones, zone ids to indexes.

    Returns a dict with the root fields (YAML keys), 'zones' (full field sets, in index order, each with
    its 'id') and 'connections' (with zone indexes)."""
    stem = os.path.splitext(os.path.basename(path))[0]
    with open(path, encoding="utf-8") as file:
        source = yaml.safe_load(file) or {}
    check_keys(source, ROOT_KEYS, stem)
    template = {"name": stem}
    for key, default in ROOT_DEFAULTS.items():
        template[key] = source.get(key, default)
    if template["name_file"] is None:
        template["name_file"] = f"{stem}.txt"
    template["title"] = source.get("title")
    template["description"] = source.get("description")
    if template["description"] and not template["description_file"]:
        template["description_file"] = f"{stem}-description.txt"
    for key in ("players", "map_size"):
        value = template[key]
        if not (isinstance(value, list) and len(value) == 2 and value[0] <= value[1]):
            raise TemplateError(f"{stem}: {key} must be [min, max]")

    profiles = dict(shared_profiles)
    profiles.update(source.get("profiles") or {})

    # Zone entries, in index order: the per-player zones (each one for every player), then the others
    entries = []
    per_player = source.get("per_player") or {}
    check_keys(per_player, {"copies", "zones", "connections"}, f"{stem}: per_player")
    copies = per_player.get("copies", template["players"][1])
    for i, entry in enumerate(per_player.get("zones") or []):
        if "id" not in entry:
            raise TemplateError(f"{stem}: per_player zone #{i + 1} has no id")
        for player in range(1, copies + 1):
            entries.append((f"{entry['id']}{player}", entry))
    for i, entry in enumerate(source.get("zones") or []):
        entries.append((entry.get("id"), entry))

    zones, ids = [], {}
    for index, (zone_id, entry) in enumerate(entries, start=1):
        zone_id = index if zone_id is None else zone_id
        if zone_id in ids:
            raise TemplateError(f"{stem}: duplicate zone id '{zone_id}'")
        ids[zone_id] = index
        zone = build_zone(entry, profiles, f"{stem}: zone '{zone_id}'")
        zone["id"] = zone_id
        zones.append(zone)

    def index_of(zone_id, where):
        # A number is a zone index unless a zone has it as id
        if zone_id in ids:
            return ids[zone_id]
        if isinstance(zone_id, int) and 1 <= zone_id <= len(zones):
            return zone_id
        raise TemplateError(f"{where}: unknown zone '{zone_id}'")

    def connection(entry, source_id, dest_id, where):
        check_keys(entry, {"from", "to"} | set(CONNECTION_DEFAULTS), where)
        result = {"from": index_of(source_id, where), "to": index_of(dest_id, where)}
        for key, default in CONNECTION_DEFAULTS.items():
            result[key] = entry.get(key, default)
        return result

    connections = []
    # Per-player connections link the zones of one player; "next.<id>" is that zone of the next player, and an
    # id that is not a per-player zone is a shared zone
    per_player_ids = {entry["id"] for entry in per_player.get("zones") or []}
    pairs = set()
    for entry in per_player.get("connections") or []:
        for player in range(1, copies + 1):
            def player_id(ref):
                if isinstance(ref, str) and ref.startswith("next."):
                    return f"{ref[5:]}{player % copies + 1}"
                return f"{ref}{player}" if ref in per_player_ids else ref
            source_id, dest_id = player_id(entry["from"]), player_id(entry["to"])
            pair = frozenset((source_id, dest_id))
            if pair in pairs:  # next.<id> with 2 players: 1 -> 2 and 2 -> 1 are the same connection
                continue
            pairs.add(pair)
            connections.append(connection(entry, source_id, dest_id, f"{stem}: per_player connection"))
    for entry in source.get("connections") or []:
        connections.append(connection(entry, entry.get("from"), entry.get("to"), f"{stem}: connection"))

    template["zones"] = zones
    template["connections"] = connections
    template["teams"] = load_teams(source.get("teams"), template, stem)
    return template


def load_teams(teams, template, stem):
    """{player count: team of each start zone, in player order}, sorted by player count.

    Written as <Teams>, an element the engine skips: the H5X DLL reads it and fixes the teams of the map."""
    if not teams:
        return {}
    if not isinstance(teams, dict):
        raise TemplateError(f"{stem}: teams must map a player count to a list of teams")
    starts = sum(1 for zone in template["zones"] if zone["start"])
    low, high = template["players"]
    result = {}
    for count, team_list in sorted(teams.items()):
        where = f"{stem}: teams for {count} players"
        if not isinstance(count, int) or not low <= count <= high:
            raise TemplateError(f"{where}: the template is for {low}-{high} players")
        if count > starts:
            raise TemplateError(f"{where}: the template has {starts} start zones")
        if not isinstance(team_list, list) or len(team_list) != count:
            raise TemplateError(f"{where}: give {count} teams, one per start zone in player order")
        if not all(isinstance(team, int) and team >= 1 for team in team_list):
            raise TemplateError(f"{where}: teams are numbers from 1")
        result[count] = team_list
    return result


def map_sides(template, underground=False):
    """Map sides of the RMG screen that list the template (without water, which counts 0.7 of the area).

    With underground, both levels count, and the template needs a MaxMapSize of 10 or more."""
    low, high = template["map_size"]
    if underground and high <= 9:
        return []
    factor = 2 if underground else 1
    return [side for side, units in MAP_SIZES if low <= units * factor <= high]


def check_template(template):
    """Warnings about a template that the game would accept but that is likely wrong."""
    warnings = []
    zones, connections = template["zones"], template["connections"]
    starts = sum(1 for zone in zones if zone["start"])
    if starts < template["players"][1]:
        warnings.append(f"{starts} start zones for {template['players'][1]} players")
    if not map_sides(template) and not map_sides(template, underground=True):
        warnings.append(f"map_size {template['map_size']} matches no map size of the RMG screen")
    for zone in zones:
        if zone["start"] and not zone["town"]:
            warnings.append(f"start zone '{zone['id']}' has no town")
        if zone["setting"] not in SETTINGS:
            warnings.append(f"zone '{zone['id']}': unknown setting {zone['setting']}")
    linked = {1} if zones else set()
    changed = True
    while changed:
        changed = False
        for c in connections:
            for a, b in ((c["from"], c["to"]), (c["to"], c["from"])):
                if a in linked and b not in linked:
                    linked.add(b)
                    changed = True
    unreachable = [zones[i - 1]["id"] for i in range(1, len(zones) + 1) if i not in linked]
    if unreachable:
        warnings.append(f"zones not connected to zone 1: {', '.join(map(str, unreachable))}")
    for count, team_list in template["teams"].items():
        if len(set(team_list)) < 2:
            warnings.append(f"teams for {count} players: everyone is in the same team")
        elif sorted(set(team_list)) != list(range(1, len(set(team_list)) + 1)):
            warnings.append(f"teams for {count} players: team numbers skip a number")
    for c in connections:
        if c["from"] == c["to"]:
            warnings.append(f"zone '{zones[c['from'] - 1]['id']}' is connected to itself")
    return warnings
