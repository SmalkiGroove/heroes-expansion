"""Generates the random map generator (RMG) templates from their YAML sources.

Each tools/generators/rmg-templates/<name>.yml becomes game_data/maps/RMG/Templates/<name>.xdb, and its
`title` / `description` become game_texts/texts-EN/RMG/Templates/<name_file> / <description_file>. The
game lists every template of /RMG/Templates/ by itself. Templates without a source are deleted, and so
are the name and description texts that no source writes. _profiles.yml holds profiles that every
source can use. The format is described in .cursor/rules/rmg.md.

Given source files (from any folder, e.g. rmg-templates/examples/), only those are generated and
nothing is removed: with --dry-run --preview, that draws a template without writing it.

--preview FILE draws the zone graph of every template in an HTML page: disc area by zone size, start
zones in player colors and in player order, towns with a white ring, treasure block value under the
zone, connection guard strength on the line, and the teams of each player count above the graph.
Hovering a zone or a connection lists its fields.
"""

import argparse
import glob
import html
import math
import os
import random
import sys

from jinja2 import Environment, FileSystemLoader

from common import GENERATORS_DIR, NEWLINE, REPO_ROOT
from rmg_common import (CONNECTION_GUARD_POWER, RESOURCES, SOURCES_DIR, TEMPLATES_DIR, TEXTS_DIR, TOWN_GUARD_POWER,
                        ZONE_DEFAULTS, ZONE_FIELDS, TemplateError, check_template, load_shared_profiles,
                        load_template, map_sides)

PLAYER_COLORS = ("#d94a4a", "#3f74d9", "#3fa45b", "#d9a12b", "#8a55c9", "#2ba6a6", "#d96ea8", "#8a8a8a")


def xdb_variables(template):
    def xdb(value):
        return ("true" if value else "false") if isinstance(value, bool) else value

    zones = [[(tag, kind, xdb(zone[key])) for key, tag, kind, _ in ZONE_FIELDS] for zone in template["zones"]]
    connections = [{k: xdb(v) for k, v in c.items()} for c in template["connections"]]
    variables = {k: xdb(v) for k, v in template.items() if k not in ("zones", "connections")}
    variables.update(zones=zones, connections=connections)
    return variables


# --- Preview -------------------------------------------------------------------------------------

def layout(template, width, height):
    """Force-directed positions of the zones (Fruchterman-Reingold), the same on every run."""
    zones, connections = template["zones"], template["connections"]
    n = len(zones)
    rng = random.Random(template["name"])
    pos = [[math.cos(2 * math.pi * i / n) + rng.uniform(-0.05, 0.05),
            math.sin(2 * math.pi * i / n) + rng.uniform(-0.05, 0.05)] for i in range(n)]
    k = 1.6 / math.sqrt(n)
    temperature = 0.3
    for _ in range(400):
        disp = [[0.0, 0.0] for _ in range(n)]
        for i in range(n):
            for j in range(i + 1, n):
                dx, dy = pos[i][0] - pos[j][0], pos[i][1] - pos[j][1]
                d = max(math.hypot(dx, dy), 1e-3)
                f = k * k / d
                disp[i][0] += dx / d * f
                disp[i][1] += dy / d * f
                disp[j][0] -= dx / d * f
                disp[j][1] -= dy / d * f
        for c in connections:
            i, j = c["from"] - 1, c["to"] - 1
            if i == j:
                continue
            dx, dy = pos[i][0] - pos[j][0], pos[i][1] - pos[j][1]
            d = max(math.hypot(dx, dy), 1e-3)
            f = d * d / k
            disp[i][0] -= dx / d * f
            disp[i][1] -= dy / d * f
            disp[j][0] += dx / d * f
            disp[j][1] += dy / d * f
        for i in range(n):
            d = max(math.hypot(*disp[i]), 1e-9)
            step = min(d, temperature)
            pos[i][0] += disp[i][0] / d * step
            pos[i][1] += disp[i][1] / d * step
        temperature *= 0.985
    xs, ys = [p[0] for p in pos], [p[1] for p in pos]
    span = max(max(xs) - min(xs), max(ys) - min(ys), 1e-3)
    margin = 50
    scale = min(width, height) - 2 * margin
    cx, cy = (max(xs) + min(xs)) / 2, (max(ys) + min(ys)) / 2
    return [(width / 2 + (x - cx) / span * scale, height / 2 + (y - cy) / span * scale) for x, y in pos]


def zone_tooltip(zone, index):
    lines = [f"Zone {index} ({zone['id']})" if zone["id"] != index else f"Zone {index}"]
    for key, _, kind, _ in ZONE_FIELDS:
        value = zone[key]
        if value == ZONE_DEFAULTS[key] and key not in ("size",):
            continue
        if kind == "mines":
            value = ", ".join(f"{res} {n}" for res, n in zip(RESOURCES, value) if n)
        elif kind == "list":
            value = ", ".join(f"tier {tier} x{n}" for tier, n in enumerate(value, start=1) if n) or "none"
        elif key == "town_guard" and zone["town"]:
            value = f"{value} (power {value * TOWN_GUARD_POWER})"
        lines.append(f"{key}: {value}")
    return "\n".join(lines)


def preview_svg(template):
    width, height = 560, 440
    zones, connections = template["zones"], template["connections"]
    pos = layout(template, width, height)
    radius = [7 + 3.2 * math.sqrt(zone["size"]) for zone in zones]
    out = [f'<svg viewBox="0 0 {width} {height}" role="img" aria-label="Zone graph of {html.escape(template["name"])}">']
    for c in connections:
        (x1, y1), (x2, y2) = pos[c["from"] - 1], pos[c["to"] - 1]
        tip = f"{c['from']} - {c['to']}: guard {c['guard']} (power {c['guard'] * CONNECTION_GUARD_POWER})"
        mx, my = (x1 + x2) / 2, (y1 + y2) / 2
        out.append(f'<g class="edge"><title>{html.escape(tip)}</title>'
                   f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}"/>'
                   f'<rect x="{mx - 13:.1f}" y="{my - 8:.1f}" width="26" height="16" rx="4"/>'
                   f'<text x="{mx:.1f}" y="{my + 4:.1f}">{c["guard"]}</text></g>')
    player = 0
    for index, (zone, (x, y), r) in enumerate(zip(zones, pos, radius), start=1):
        if zone["start"]:
            fill = PLAYER_COLORS[player % len(PLAYER_COLORS)]
            player += 1
        else:
            fill = "var(--zone)"
        label = zone["id"] if isinstance(zone["id"], str) else str(index)
        classes = "zone" + (" town" if zone["town"] else "") + (" start" if zone["start"] else "")
        out.append(f'<g class="{classes}"><title>{html.escape(zone_tooltip(zone, index))}</title>'
                   f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r:.1f}" style="fill:{fill}"/>'
                   f'<text x="{x:.1f}" y="{y + 4:.1f}">{html.escape(label)}</text>')
        if zone["treasure_blocks"]:
            out.append(f'<text class="value" x="{x:.1f}" y="{y + r + 13:.1f}">'
                       f'{zone["treasure_blocks"] / 1000:g}k</text>')
        out.append("</g>")
    out.append("</svg>")
    return "".join(out)


PREVIEW_CSS = """
:root { --bg: #f6f5f2; --card: #ffffff; --text: #222; --muted: #6b6b6b; --line: #8b8b8b; --zone: #c9c3b6;
        --label-bg: #ffffff; --warn: #b3261e; }
@media (prefers-color-scheme: dark) { :root:not([data-theme="light"]) {
        --bg: #1b1b1d; --card: #252528; --text: #e8e8e8; --muted: #a0a0a0; --line: #8f8f8f; --zone: #5d5a54;
        --label-bg: #303034; --warn: #ff8a80; } }
:root[data-theme="dark"] { --bg: #1b1b1d; --card: #252528; --text: #e8e8e8; --muted: #a0a0a0; --line: #8f8f8f;
        --zone: #5d5a54; --label-bg: #303034; --warn: #ff8a80; }
body { background: var(--bg); color: var(--text); font: 14px/1.4 system-ui, sans-serif; margin: 0; padding: 16px; }
h1 { font-size: 20px; margin: 0 0 4px; }
.legend { color: var(--muted); margin-bottom: 16px; }
.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(min(100%, 480px), 1fr)); gap: 16px; }
.card { background: var(--card); border-radius: 10px; padding: 12px 14px; }
.card h2 { font-size: 16px; margin: 0; }
.meta { color: var(--muted); font-size: 13px; }
.warn { color: var(--warn); font-size: 13px; }
.teams { font-size: 13px; margin-top: 4px; }
.chip { color: #fff; border-radius: 4px; padding: 0 5px; font-size: 12px; }
.vs { color: var(--muted); }
svg { width: 100%; height: auto; display: block; }
.edge line { stroke: var(--line); stroke-width: 2; }
.edge rect { fill: var(--label-bg); stroke: var(--line); }
.edge text, .zone text { text-anchor: middle; font-size: 11px; fill: var(--text); }
.zone circle { stroke: var(--card); stroke-width: 2; }
.zone.town circle { stroke: #fff; stroke-width: 4; }
.zone.start text { fill: #fff; font-weight: 600; }
.zone text.value { fill: var(--muted); font-size: 10px; font-weight: 400; }
"""


def teams_html(template):
    """One line per player count: the start zones of each team, in their player colors."""
    starts = [zone for zone in template["zones"] if zone["start"]]
    lines = []
    for count, team_list in template["teams"].items():
        groups = {}
        for player, team in enumerate(team_list):
            zone = starts[player]
            label = zone["id"] if isinstance(zone["id"], str) else str(zone["id"])
            color = PLAYER_COLORS[player % len(PLAYER_COLORS)]
            groups.setdefault(team, []).append(f'<span class="chip" style="background:{color}">{html.escape(label)}</span>')
        teams = ' <span class="vs">vs</span> '.join(" ".join(chips) for _, chips in sorted(groups.items()))
        lines.append(f'<div class="teams">{count} players: {teams}</div>')
    return "".join(lines)


def write_preview(templates, warnings, path):
    cards = []
    for template in templates:
        title = template["title"] or template["name_file"]
        sides = ", ".join(map(str, map_sides(template))) or "none"
        sides_underground = ", ".join(map(str, map_sides(template, underground=True))) or "none"
        meta = (f"{len(template['zones'])} zones, {template['players'][0]}-{template['players'][1]} players, "
                f"maps {sides} (with underground: {sides_underground})"
                + (", grail" if template["grail"] else "") + (", test (hidden)" if template["test"] else ""))
        warn = "".join(f'<div class="warn">{html.escape(w)}</div>' for w in warnings.get(template["name"], []))
        cards.append(f'<section class="card"><h2>{html.escape(template["name"])}</h2>'
                     f'<div class="meta">{html.escape(str(title))}</div><div class="meta">{html.escape(meta)}</div>'
                     f'{teams_html(template)}{warn}{preview_svg(template)}</section>')
    page = (f'<!doctype html><html lang="en"><head><meta charset="utf-8">'
            f'<meta name="viewport" content="width=device-width, initial-scale=1">'
            f'<title>RMG Templates</title><style>{PREVIEW_CSS}</style></head><body>'
            f'<h1>RMG templates</h1><div class="legend">Disc area: zone size. Colored: start zones, in player '
            f'order. White ring: town. Under a zone: treasure block value. On a connection: guard strength '
            f'(x{CONNECTION_GUARD_POWER} power; zones that don\'t touch get a guarded teleport). Hover for every '
            f'field.</div>'
            f'<div class="grid">{"".join(cards)}</div></body></html>')
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    with open(path, "w", encoding="utf-8") as file:
        file.write(page)
    print(f"Preview: {path}")


# --- Main ----------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true", help="check and render everything, write no game file")
    parser.add_argument("--preview", metavar="FILE", help="draw the zone graphs in an HTML page")
    parser.add_argument("files", nargs="*",
                        help="generate only these sources (from any folder) and remove nothing (default: every source)")
    args = parser.parse_args()

    env = Environment(loader=FileSystemLoader(os.path.join(GENERATORS_DIR, "templates-rmg")),
                      trim_blocks=True, lstrip_blocks=True, keep_trailing_newline=True)
    xdb_template = env.get_template("RMGTemplate.xdb.j2")
    shared_profiles = load_shared_profiles()

    templates, warnings, errors = [], {}, 0
    paths = args.files or sorted(glob.glob(os.path.join(SOURCES_DIR, "*.yml")))
    for path in paths:
        if not args.files and os.path.basename(path).startswith("_"):
            continue
        try:
            template = load_template(path, shared_profiles)
        except TemplateError as error:
            print(f"ERROR: {error}")
            errors += 1
            continue
        templates.append(template)
        warnings[template["name"]] = check_template(template)
        for warning in warnings[template["name"]]:
            print(f"WARN: {template['name']}: {warning}")
    if errors:
        sys.exit(f"{errors} template(s) with errors, nothing written")

    written_xdb, written_texts = set(), set()
    for template in templates:
        xdb_path = os.path.join(TEMPLATES_DIR, f"{template['name']}.xdb")
        written_xdb.add(os.path.normcase(xdb_path))
        content = xdb_template.render(xdb_variables(template))
        texts = []
        if template["title"] is not None:
            texts.append((template["name_file"], template["title"]))
        if template["description"] is not None:
            texts.append((template["description_file"], template["description"]))
        for file_ref, text in texts:
            if file_ref.startswith("/") or "/" in file_ref:
                sys.exit(f"{template['name']}: a text needs a file name next to the template, not {file_ref}")
            text_path = os.path.join(TEXTS_DIR, file_ref)
            written_texts.add(os.path.normcase(text_path))
            if not args.dry_run:
                os.makedirs(TEXTS_DIR, exist_ok=True)
                with open(text_path, "w", encoding="utf-16") as file:
                    file.write(str(text).strip())
        if not args.dry_run:
            os.makedirs(TEMPLATES_DIR, exist_ok=True)
            with open(xdb_path, "w", encoding="utf-8", newline=NEWLINE) as file:
                file.write(content)

    # Templates and texts that no source produces any more
    stale = []
    if not args.files:
        stale += [p for p in glob.glob(os.path.join(TEMPLATES_DIR, "*.xdb")) if os.path.normcase(p) not in written_xdb]
        stale += [p for p in glob.glob(os.path.join(TEXTS_DIR, "*.txt")) if os.path.normcase(p) not in written_texts]
    for path in stale:
        print(f"Remove stale {os.path.relpath(path, REPO_ROOT)}")
        if not args.dry_run:
            os.remove(path)

    print(f"{len(templates)} templates" + (" checked (dry run)" if args.dry_run else " written"))
    if args.preview:
        write_preview(templates, warnings, args.preview)


if __name__ == "__main__":
    main()
