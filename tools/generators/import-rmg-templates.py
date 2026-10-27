"""Converts RMG templates (.xdb) into template sources (YAML) for generate-rmg-templates.py.

By default, imports every template of game_data/maps/RMG/Templates/ into tools/generators/rmg-templates/,
without overwriting an existing source (--force does). Zones with the same fields share a profile. The
generator rebuilds the imported templates byte for byte.
"""

import argparse
import glob
import json
import os
import re

from common import REPO_ROOT, items, load_xdb
from rmg_common import (CONNECTION_FIELDS, RESOURCES, SOURCES_DIR, TEMPLATES_DIR, ZONE_DEFAULTS, ZONE_FIELDS)


def to_bool(text):
    return text == "true"


def read_template(path):
    root = load_xdb(path)["RMGTemplate"]
    zones = []
    for item in items(root["Zones"]):
        zone = {}
        for key, tag, kind, _ in ZONE_FIELDS:
            node = item.get(tag)
            if kind == "bool":
                zone[key] = to_bool(node)
            elif kind == "int":
                zone[key] = int(node)
            elif kind == "str":
                zone[key] = node
            else:
                zone[key] = tuple(int(v) for v in items(node))
        zones.append(zone)
    connections = []
    for item in items(root["Connections"]):
        connection = {"from": int(item["SourceZoneIndex"]), "to": int(item["DestZoneIndex"])}
        for key, tag, default in CONNECTION_FIELDS:
            connection[key] = to_bool(item[tag]) if isinstance(default, bool) else int(item[tag])
        connections.append(connection)
    return {
        "name": root["Name"],
        "name_file": root["NameFileRef"]["@href"],
        "description_file": root["DescriptionFileRef"]["@href"],
        "players": [int(root["MinPlayers"]), int(root["MaxPlayers"])],
        "map_size": [int(root["MinMapSize"]), int(root["MaxMapSize"])],
        "underground": to_bool(root["Underground"]),
        "grail": to_bool(root["GraalOnMap"]),
        "test": to_bool(root["TestTemplate"]),
        "zones": zones,
        "connections": connections,
    }


def scalar(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, (list, tuple)):
        return "[" + ", ".join(scalar(v) for v in value) + "]"
    if isinstance(value, dict):
        return "{" + ", ".join(f"{k}: {scalar(v)}" for k, v in value.items()) + "}"
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_./-]*", value) and value not in ("true", "false", "null", "yes", "no"):
        return value
    return json.dumps(value)


def zone_fields(zone):
    """Fields of a zone that differ from the defaults, in XDB order, mines as {resource: count}."""
    fields = {}
    for key, _, kind, _ in ZONE_FIELDS:
        if zone[key] == ZONE_DEFAULTS[key]:
            continue
        if kind == "mines":
            fields[key] = {res: n for res, n in zip(RESOURCES, zone[key]) if n}
        else:
            fields[key] = zone[key]
    return fields


def block(fields, indent):
    return [f"{indent}{key}: {scalar(value)}" for key, value in fields.items()]


def to_yaml(template, stem):
    lines = [f"# Imported from {stem}.xdb by import-rmg-templates.py"]
    if template["name"] != stem:
        lines.append(f"# <Name> was {template['name']}, it is now the file name")
    if template["name_file"] != f"{stem}.txt":
        lines.append(f"name_file: {scalar(template['name_file'])}")
    if template["description_file"]:
        lines.append(f"description_file: {scalar(template['description_file'])}")
    for key in ("players", "map_size", "underground", "grail"):
        lines.append(f"{key}: {scalar(template[key])}")
    if template["test"]:
        lines.append("test: true")

    # Zones with the same fields share a profile, named after the first zone's role
    groups = {}
    for zone in template["zones"]:
        groups.setdefault(tuple(sorted(zone.items())), []).append(zone)
    profile_of, names = {}, set()
    for signature, members in groups.items():
        if len(members) < 2:
            continue
        zone = members[0]
        base = "start" if zone["start"] else "town" if zone["town"] else "zone"
        name, n = base, 1
        while name in names:
            n += 1
            name = f"{base}{n}"
        names.add(name)
        profile_of[signature] = name
    if profile_of:
        lines += ["", "profiles:"]
        for signature, name in profile_of.items():
            lines.append(f"  {name}:")
            lines += block(zone_fields(dict(signature)), "    ") or ["    {}"]

    lines += ["", "zones:"]
    for index, zone in enumerate(template["zones"], start=1):
        lines.append(f"  # {index}")
        name = profile_of.get(tuple(sorted(zone.items())))
        fields = {"profile": name} if name else zone_fields(zone)
        zone_lines = block(fields, "    ") or ["    {}"]
        zone_lines[0] = "  - " + zone_lines[0][4:]
        lines += zone_lines

    lines += ["", "connections:"]
    for c in template["connections"]:
        fields = {"from": c["from"], "to": c["to"], "guard": c["guard"]}
        for key, _, default in CONNECTION_FIELDS:
            if key != "guard" and c[key] != default:
                fields[key] = c[key]
        lines.append(f"  - {scalar(fields)}")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("files", nargs="*", help="template .xdb files (default: every template of the mod)")
    parser.add_argument("--out", default=SOURCES_DIR, help="folder of the YAML sources")
    parser.add_argument("--force", action="store_true", help="overwrite existing sources")
    args = parser.parse_args()

    files = args.files or sorted(glob.glob(os.path.join(TEMPLATES_DIR, "*.xdb")))
    os.makedirs(args.out, exist_ok=True)
    for path in files:
        stem = os.path.splitext(os.path.basename(path))[0]
        out_path = os.path.join(args.out, f"{stem}.yml")
        if os.path.exists(out_path) and not args.force:
            print(f"Skip {stem}: {os.path.relpath(out_path, REPO_ROOT)} exists (--force overwrites it)")
            continue
        with open(out_path, "w", encoding="utf-8", newline="\n") as file:
            file.write(to_yaml(read_template(path), stem))
        print(f"Imported {stem}")


if __name__ == "__main__":
    main()
