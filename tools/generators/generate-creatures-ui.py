"""Generates the Creatures tab of the encyclopedia (game_data/www-creatures/UI/Doc/Creatures).

Two creatures are compared side by side: the stats of the left creature are on the left of the stat icons of the central
panel, the ones of the right creature on their right. Each side has its own row of faction buttons (at the same place:
the side buttons on top of the panel show one row or the other) and its own creature grid (left or right of the panel).
Clicking a creature of a grid shows its stats in the column of that side.
Hand-made: the Creatures.(WindowSimple) instance, _Buttons/ and Common/. Every other file is generated, and stale files
are removed.
"""

import os
from common import Generator, GAME_DATA, warn, load_xdb, as_list, items, href_path, game_path

gen = Generator("templates-creatures", __doc__)

creatures_pedia_path = os.path.join(GAME_DATA, "www-creatures", "UI", "Doc", "Creatures")
creatures_table = load_xdb(GAME_DATA, "creatures", "GameMechanics", "RefTables", "Creatures.xdb")
abilities_table = load_xdb(GAME_DATA, "creatures", "GameMechanics", "RefTables", "CombatAbilities.xdb")
spells_table = load_xdb(GAME_DATA, "spells", "GameMechanics", "RefTables", "UndividedSpells.xdb")

# Hand-made files of the tab, relative to creatures_pedia_path
hand_made = ("Creatures.(WindowSimple).xdb", "_Buttons/", "Common/")

# Factions in the order of their buttons: name, folder of their creatures in GameMechanics/Creature/Creatures,
# texture of their button (/UI/Doc/Common/<texture>) and name text (its tooltip)
factions = [
    ("Neutral", "Neutrals", "Neutral", "/UI/Doc/Creatures/Common/Neutral.txt"),
    ("Haven", "Haven", "Haven", "/GameMechanics/RefTables/Haven.txt"),
    ("Inferno", "Inferno", "Inferno", "/GameMechanics/RefTables/Inferno.txt"),
    ("Necro", "Necropolis", "Necropolis", "/GameMechanics/RefTables/Necropolis.txt"),
    ("Preserve", "Preserve", "Preserve", "/GameMechanics/RefTables/Preserve.txt"),
    ("Dungeon", "Dungeon", "Dungeon", "/GameMechanics/RefTables/Dungeon.txt"),
    ("Academy", "Academy", "Academy", "/GameMechanics/RefTables/Academy.txt"),
    ("Fortress", "Dwarf", "Fortress", "/GameMechanics/RefTables/Fortress.txt"),
    ("Stronghold", "Orcs", "Stronghold", "/GameMechanics/RefTables/Stronghold.txt"),
]
default_faction = "Haven"
sides = ["L", "R"]
default_side = "L"

# Stat rows of the central panel: (key, tooltip of its icon). The icons are hand-made, Common/Stats/<key>.
stat_rows = [
    ("Tier", "/UI/Doc/Creatures/Common/Tier.txt"),
    ("Growth", "/UI/Doc/Creatures/Common/Growth.txt"),
    ("Cost", "/UI/Doc/Creatures/Common/Cost.txt"),
    ("Health", "/UI/Tooltips/CreatureInfo/Hitpoints.txt"),
    ("Attack", "/UI/Tooltips/CreatureInfo/attack.txt"),
    ("Defense", "/UI/Tooltips/CreatureInfo/Defense.txt"),
    ("Damages", "/UI/Tooltips/CreatureInfo/damage.txt"),
    ("Range", "/UI/Doc/Creatures/Common/Shots.txt"),
    ("Speed", "/UI/Tooltips/CreatureInfo/speed.txt"),
    ("Initiative", "/UI/Tooltips/CreatureInfo/initiative.txt"),
    ("Mana", "/UI/Tooltips/CreatureInfo/mana.txt"),
]
spells_row = ("Spells", "/UI/Doc/Creatures/Common/Spells.txt")
abilities_row = ("Abilities", "/UI/Doc/Creatures/Common/Abilities.txt")
# Resources of the creature costs, with their vanilla icon (/UI/Common/Resources/<icon>.(Texture).xdb, 16x15)
resource_icons = {"Wood": "Wood", "Ore": "Ore", "Mercury": "Mercury", "Crystal": "Crystal", "Sulfur": "Sulfur", "Gem": "Gems"}
resource_step = 18
# Width of a cost text with resources ("5000 + 1", always 4 digits of gold), estimated in the value font: on the right
# side, the resource icons follow it
cost_text_width = 60

# Layout, in pixels of the Creatures window (1024x1024, its parchment ends at y=700)
faction_button_x, faction_button_step, faction_button_y, faction_button_size = 80, 70, 60, 61
selection_glow = "/UI/Doc/Skills/Common/Highlight.(BackgroundSimpleScallingTexture).xdb"
selection_padding = 6
# Central panel: the PageDisabled texture draws the panel on the top-left 302x472 of its 512x512, and the whole
# texture is scaled to its window
panel_x, panel_y, panel_width = 291, 150, 380
panel_texture = (512, 512)
panel_picture = (302, 472)
icon_size = 16
column_gap = 6                                   # between a column and the icons, and the panel border
column_width = (panel_width - icon_size) // 2 - 2 * column_gap
icon_x = panel_x + (panel_width - icon_size) // 2
column_x = {'L': panel_x + column_gap, 'R': icon_x + icon_size + column_gap}
# The values are aligned towards the icons, value_gap away from them: on the right on the left side, and on the left on
# the right side (the name, spells and abilities are centered). (x, width) in the column, and format
value_gap = 30
value_box = {'L': (0, column_width - (value_gap - column_gap)), 'R': (value_gap - column_gap, column_width - (value_gap - column_gap))}
value_format = {'L': "ValueRight", 'R': "ValueLeft"}
# Side buttons, centered on their column, straddling the top border of the panel
side_button_size = 40
side_button_y = panel_y - side_button_size // 2
# Inside a column, from column_top: the creature icon, its name, the stat rows (with an extra space after the rows of
# row_space), the spells (one row, aligned like the values), then the abilities. The panel ends just above the bottom
# of the parchment.
column_top = panel_y + side_button_size // 2 + 4
creature_icon_size = 48
name_y, name_height = creature_icon_size + 2, 26
row_top = name_y + name_height + 4
row_step = 20
row_space = {"Cost": 10}
row_y = []
for key, _ in stat_rows:
    row_y.append(row_y[-1] + row_step + row_space.get(previous, 0) if row_y else row_top)
    previous = key
spell_icon_size, spell_step, spell_count = 32, 34, 4
spells_top = row_y[-1] + row_step + 4
ability_step, ability_rows = 17, 8
abilities_top = spells_top + spell_step + 4
column_height = abilities_top + ability_rows * ability_step
panel_box = (panel_x, panel_y, panel_width, column_top - panel_y + column_height + column_gap)
# Creature grids: 7 rows of 3 cells (a tier: its base creature and its 2 upgrades), left and right of the panel
grid_columns, grid_rows = 3, 7
cell_size, cell_icon_size = 64, 52
cell_step = (80, 68)
grid_width = (grid_columns - 1) * cell_step[0] + cell_size
grid_height = (grid_rows - 1) * cell_step[1] + cell_size
grid_x = {'L': (45 + panel_box[0] - grid_width) // 2, 'R': (panel_box[0] + panel_box[2] + 935 - grid_width) // 2}
grid_y = panel_box[1]
# Drawing priorities: the glows below the cell frames and the icons; the panel below the grids, which overlap its
# texture window
glow_priority, panel_priority, grid_priority, column_priority, button_priority = 0, 0, 1, 2, 3


def out_path(*parts):
    return os.path.join(creatures_pedia_path, *parts)

def doc_path(*parts):
    """In-game path of a file of the tab."""
    return game_path("UI/Doc/Creatures", *parts)

def child(href, ui_type):
    return {'href': href, 'type': ui_type}

def write_window(parts, name, visible, box, children=(), background=None, priority=0, tooltip='', shared=None):
    """A WindowSimple instance (parts: its path in the tab, without the type) and its own Shared file, unless it uses
    the shared one given."""
    if shared is None:
        shared = doc_path(*parts[:-1], f"{parts[-1]}.(WindowSimpleShared).xdb")
        gen.write("window.(WindowSimpleShared).xdb.j2", out_path(*parts[:-1], f"{parts[-1]}.(WindowSimpleShared).xdb"),
                  {'children': children, 'background': background, 'w': box[2], 'h': box[3]})
    gen.write("window.(WindowSimple).xdb.j2", out_path(*parts[:-1], f"{parts[-1]}.(WindowSimple).xdb"),
              {'name': name, 'shared': shared, 'visible': visible, 'priority': priority, 'tooltip': tooltip,
               'x': box[0], 'y': box[1], 'w': box[2], 'h': box[3]})
    return child(doc_path(*parts[:-1], f"{parts[-1]}.(WindowSimple).xdb"), "WindowSimple")

def write_background(parts, texture, size):
    gen.write("background.(BackgroundSimpleScallingTexture).xdb.j2", out_path(*parts[:-1], f"{parts[-1]}.(BackgroundSimpleScallingTexture).xdb"),
              {'path': texture, 'size': size})
    return doc_path(*parts[:-1], f"{parts[-1]}.(BackgroundSimpleScallingTexture).xdb")

def write_messages(parts, target):
    """The 2 messages showing and hiding a window, returns their hrefs (show, hide)."""
    hrefs = []
    for suffix, value in (("Show", 1), ("Hide", 0)):
        file = f"{parts[-1]}{suffix}.(UISSendUIMessage).xdb"
        gen.write("message.(UISSendUIMessage).xdb.j2", out_path(*parts[:-1], file),
                  {'message': "UI_SHOW_WINDOW", 'target': target, 'forward': value, 'back': 1 - value})
        hrefs.append(doc_path(*parts[:-1], file))
    return hrefs

def write_button_shared(parts, icon):
    """Visuals of a click button drawing an icon (the background of each sub-state)."""
    gen.write("clickbutton.(WindowMSButtonShared).xdb.j2", out_path(*parts[:-1], f"{parts[-1]}.(WindowMSButtonShared).xdb"),
              {'icon': f"{icon}#xpointer(/BackgroundSimpleScallingTexture)", 'hover_commands': []})
    return doc_path(*parts[:-1], f"{parts[-1]}.(WindowMSButtonShared).xdb")

def write_click_button(parts, name, pos, size, shared, commands, tooltip='', priority=button_priority):
    gen.write("clickbutton.(WindowMSButton).xdb.j2", out_path(*parts[:-1], f"{parts[-1]}.(WindowMSButton).xdb"),
              {'shared': shared, 'name': name, 'tooltip': tooltip, 'priority': priority,
               'pos_x': pos[0], 'pos_y': pos[1], 'size': size, 'commands': commands})
    return child(doc_path(*parts[:-1], f"{parts[-1]}.(WindowMSButton).xdb"), "WindowMSButton")

def write_text_view(parts, name, text_ref, text_format, box, priority=column_priority, tooltip=''):
    gen.write("textview.(WindowTextView).xdb.j2", out_path(*parts[:-1], f"{parts[-1]}.(WindowTextView).xdb"),
              {'name': name, 'text_ref': text_ref, 'format': text_format, 'priority': priority, 'tooltip': tooltip,
               'x': box[0], 'y': box[1], 'w': box[2], 'h': box[3]})
    return child(doc_path(*parts[:-1], f"{parts[-1]}.(WindowTextView).xdb"), "WindowTextView")

def resolve(href, data_path):
    """Absolute game path of an href read in the data file data_path (relative hrefs are relative to its folder)."""
    return href if href.startswith('/') else game_path(os.path.dirname(data_path), href)

def table(data, root):
    return {item['ID']: item for item in as_list(data[root]['objects']['Item'])}


# Names and descriptions (the tooltips of the names) of the abilities
ability_names, ability_descriptions = {}, {}
for ability_id, item in table(abilities_table, "Table_CreatureAbility_CombatAbility").items():
    for texts, field in ((ability_names, 'NameFileRef'), (ability_descriptions, 'DescriptionFileRef')):
        href = ((item.get('obj') or {}).get(field) or {}).get('@href')
        if href:
            texts[ability_id] = resolve(href, "GameMechanics/RefTables/CombatAbilities.xdb")
spells = table(spells_table, "Table_Spell_SpellID")

def spell_icon(spell_id):
    """Icon and name of a spell that has an icon, else None."""
    if spell_id not in spells:
        warn(f"unknown spell {spell_id}")
        return None
    path = href_path(spells[spell_id]['Obj']['@href'])
    spell_data = load_xdb(GAME_DATA, "spells", path)['Spell']
    if not (spell_data.get('Texture') or {}).get('@href'):
        gen.log(f"Skip spell {spell_id}, it has no icon")
        return None
    return {'icon': resolve(spell_data['Texture']['@href'], path), 'name': resolve(spell_data['NameFileRef']['@href'], path)}


def get_creatures():
    """The creatures of each faction in grid order: by tier, the base creature then its upgrades in the order of its
    Upgrades list; the neutrals by tier. A base creature is one that isn't an upgrade of another one: the Upgrade flag
    is false for some upgrades of the third line (Inferno/3rd/)."""
    by_folder = {}
    folders = {folder for _, folder, *_ in factions}
    for creature_id, item in table(creatures_table, "Table_Creature_CreatureType").items():
        href = (item.get('Obj') or {}).get('@href')
        if not href:
            continue
        path = href_path(href)
        parts = path.split('/')
        if len(parts) < 5 or parts[3] not in folders:
            continue
        data = load_xdb(GAME_DATA, "creatures", path)['Creature']
        visual_path = href_path(resolve(data['Visual']['@href'], path))
        visual = load_xdb(GAME_DATA, "creatures", visual_path)['CreatureVisual']
        by_folder.setdefault(parts[3], {})[creature_id] = {'id': creature_id, 'data': data, 'name': resolve(visual['CreatureNameFileRef']['@href'], visual_path),
                                                           'icon': resolve(visual['Icon128']['@href'], visual_path)}
    creatures = {}
    for faction, folder, *_ in factions:
        members = by_folder.get(folder, {})
        if faction == "Neutral":
            ordered = sorted(members.values(), key=lambda c: (int(c['data']['CreatureTier']), c['data']['Upgrade'] == 'true'))
        else:
            ordered = []
            upgrades = {upgrade for c in members.values() for upgrade in items(c['data'].get('Upgrades'))}
            for base in sorted((c for c in members.values() if c['id'] not in upgrades), key=lambda c: int(c['data']['CreatureTier'])):
                ordered.append(base)
                for upgrade in items(base['data'].get('Upgrades')):
                    if upgrade in members:
                        ordered.append(members[upgrade])
                    else:
                        warn(f"{faction}: upgrade {upgrade} of {base['id']} is not a creature of the faction")
            missing = members.keys() - {c['id'] for c in ordered}
            if missing:
                warn(f"{faction}: creatures that are not an upgrade of a base creature: {sorted(missing)}")
        if len(ordered) > grid_columns * grid_rows:
            warn(f"{faction}: {len(ordered)} creatures, only {grid_columns * grid_rows} fit in the grid")
            ordered = ordered[:grid_columns * grid_rows]
        creatures[faction] = ordered
    return creatures


def value_text(value):
    """UI-local text of a stat value, shared by every creature with that value (_Values/<value>.txt)."""
    file = "None" if value == "-" else value.replace(" ", "").replace("+", "_")
    gen.write_text(out_path("_Values", f"{file}.txt"), value)
    return doc_path("_Values", f"{file}.txt")

def stat_values(data):
    """Text of each stat row, and the resources of the cost other than gold [(resource, count)]. Several resources are
    shown with a single count, the one of each (Phoenix: 1 of 4 resources)."""
    def number(key):
        return int(data.get(key) or 0)
    cost = data.get('Cost') or {}
    resources = [(resource, int(count)) for resource, count in cost.items() if resource != 'Gold' and int(count or 0) > 0]
    if len({count for _, count in resources}) > 1:
        warn(f"different counts of resources in the cost {cost}, only the first one is shown")
    damage = number('MinDamage'), number('MaxDamage')
    return {
        'Tier': str(number('CreatureTier')),
        'Growth': str(number('WeeklyGrowth')),
        'Cost': str(int(cost.get('Gold') or 0)) + (f" + {resources[0][1]}" if resources else ""),
        'Health': str(number('Health')),
        'Attack': str(number('AttackSkill')),
        'Defense': str(number('DefenceSkill')),
        'Damages': f"{damage[0]}-{damage[1]}" if damage[0] != damage[1] else str(damage[0]),
        'Range': str(number('Shots')) if number('Shots') else "-",
        'Speed': str(number('Speed')),
        'Initiative': str(number('Initiative')),
        'Mana': str(number('SpellPoints')) if number('SpellPoints') else "-",
    }, resources


def generate_stats(creature):
    """Stats of a creature: a Shared file per side for its column windows, {side: href}. The icon, name and abilities
    (centered) are the same windows on both sides."""
    creature_id, data = creature['id'], creature['data']
    folder = ("_Stats", creature_id)
    prefix = f"DocCreaturesStat{creature_id}"
    w = column_width
    children = [write_window((*folder, "Icon"), f"{prefix}Icon", True, ((w - creature_icon_size) // 2, 0, creature_icon_size, creature_icon_size),
                             background=doc_path("_Creatures", f"{creature_id}.(BackgroundSimpleScallingTexture).xdb"), priority=column_priority),
                write_text_view((*folder, "Name"), f"{prefix}Name", creature['name'], "Name", (0, name_y, w, name_height))]
    # Creature abilities cast as spells (SPELL_ABILITY_*) have no icon, and are among the abilities. The runes of the
    # Fortress rune mages (SPELL_RUNE_*) are left out.
    known = [spell['Spell'] for spell in as_list((data.get('KnownSpells') or {}).get('Item'))
             if spell and not spell['Spell'].startswith("SPELL_RUNE_") and spell_icon(spell['Spell'])]
    if len(known) > spell_count:
        warn(f"{creature_id} knows {len(known)} spells, only {spell_count} are shown")
        known = known[:spell_count]
    abilities = items(data.get('Abilities'))
    for idx, ability in enumerate(abilities):
        if ability not in ability_names:
            warn(f"{creature_id}: ability {ability} has no name")
            continue
        children.append(write_text_view((*folder, f"Ability{idx}"), f"{prefix}Ability{idx}", ability_names[ability], "Ability",
                                        (0, abilities_top + idx * ability_step, w, ability_step), tooltip=ability_descriptions.get(ability, '')))
    if len(abilities) > ability_rows:
        warn(f"{creature_id}: its {len(abilities)} abilities don't fit in the column")

    # The values, aligned towards the icons: a Shared file per side, with the windows above
    values, resources = stat_values(data)
    shared = {}
    for side in sides:
        x, width = value_box[side]
        side_children = list(children)
        for idx, (key, _) in enumerate(stat_rows):
            y = row_y[idx]
            if key == 'Cost' and resources:
                # Left side: the resource icons end where the values end, after the text; right side: they follow the text
                icons_width = len(resources) * resource_step
                if side == 'L':
                    text_box, icons_x = (x, y, width - icons_width - 2, row_step), x + width - icons_width + 2
                else:
                    text_box, icons_x = (x, y, cost_text_width, row_step), x + cost_text_width + 4
                side_children.append(write_text_view((*folder, side, key), f"{prefix}{side}{key}", value_text(values[key]), value_format[side], text_box))
                for idx_res, (resource, _) in enumerate(resources):
                    icon = write_background(("_Resources", resource), f"/UI/Common/Resources/{resource_icons[resource]}.(Texture).xdb", 16)
                    side_children.append(write_window((*folder, side, f"Resource{idx_res}"), f"{prefix}{side}Resource{idx_res}", True,
                                                      (icons_x + idx_res * resource_step, y + 2, 16, 15), background=icon, priority=column_priority))
            else:
                side_children.append(write_text_view((*folder, side, key), f"{prefix}{side}{key}", value_text(values[key]), value_format[side],
                                                     (x, y, width, row_step)))
        # The spells, aligned like the values: towards the icons
        first = x + width - (len(known) - 1) * spell_step - spell_icon_size if side == 'L' else x
        for idx, spell_id in enumerate(known):
            spell_data = spell_icon(spell_id)
            icon = write_background(("_Spells", spell_id), spell_data['icon'], 128)
            side_children.append(write_window((*folder, side, f"Spell{idx}"), f"{prefix}{side}Spell{idx}", True,
                                              (first + idx * spell_step, spells_top, spell_icon_size, spell_icon_size),
                                              background=icon, priority=column_priority, tooltip=spell_data['name']))
        gen.write("window.(WindowSimpleShared).xdb.j2", out_path(*folder, f"Stats{side}.(WindowSimpleShared).xdb"),
                  {'children': side_children, 'background': None, 'w': w, 'h': column_height})
        shared[side] = doc_path(*folder, f"Stats{side}.(WindowSimpleShared).xdb")
    return shared


def generate_panel():
    """The central panel and its stat icons, on the rows of the columns."""
    back_size = [round(size * texture / picture) for size, texture, picture in zip(panel_box[2:], panel_texture, panel_picture)]
    children = [write_window(("Panel", "Back"), "DocCreaturesPanelBack", True, (0, 0, *back_size),
                             background="/UI/Doc/Creatures/Common/Stats/_Holder.(BackgroundSimpleScallingTexture).xdb", priority=panel_priority)]
    rows = [(key, tooltip, row_y[idx]) for idx, (key, tooltip) in enumerate(stat_rows)]
    rows.append((*spells_row, spells_top + (spell_icon_size - row_step) // 2))
    rows.append((*abilities_row, abilities_top + (ability_step - row_step) // 2))
    for key, tooltip, y in rows:
        children.append(write_window(("Panel", key), f"DocCreaturesPanel{key}", True,
                                     (icon_x - panel_box[0], column_top - panel_box[1] + y + (row_step - icon_size) // 2, icon_size, icon_size),
                                     background=f"/UI/Doc/Creatures/Common/Stats/{key}.(BackgroundSimpleScallingTexture).xdb", priority=column_priority, tooltip=tooltip))
    return write_window(("Panel", "Panel"), "DocCreaturesPanel", True, (*panel_box[:2], *back_size), children, priority=panel_priority)


def generate_side_buttons():
    """The buttons on top of the panel choosing the side whose faction buttons are shown, with a glow behind the selected one."""
    factions_msg = {side: write_messages(("Side", f"Factions{side}"), f"DocCreaturesFactions{side}") for side in sides}
    sel_msg = {side: write_messages(("Side", f"{side}Sel"), f"DocCreaturesSideSel{side}") for side in sides}
    windows = []
    for side, texture in zip(sides, ["Left", "Right"]):
        others = [s for s in sides if s != side]
        x = column_x[side] + (column_width - side_button_size) // 2
        windows.append(write_window(("Side", f"{side}Sel"), f"DocCreaturesSideSel{side}", side == default_side,
                                    (x - selection_padding, side_button_y - selection_padding,
                                     side_button_size + 2 * selection_padding, side_button_size + 2 * selection_padding),
                                    background=selection_glow, priority=glow_priority))
        shared = write_button_shared(("Side", side), write_background(("Side", texture), f"/UI/Common/JogDial/Buttons/{texture}/Active.(Texture).xdb", 57))
        commands = [factions_msg[side][0]] + [factions_msg[o][1] for o in others] + [sel_msg[side][0]] + [sel_msg[o][1] for o in others]
        windows.append(write_click_button(("Side", side), f"DocCreaturesSide{side}", (x, side_button_y), side_button_size, shared, commands,
                                          tooltip=doc_path("Common", f"Side{side}.txt")))
    return windows


def generate_side(side, creatures, stats_shared):
    """Faction buttons, creature grids, selection glows and stat columns of a side."""
    def others(faction):
        return [f for f, *_ in factions if f != faction]
    # Messages of the windows toggled by the buttons
    grid_msg, glows_msg, column_msg, faction_sel_msg, stats_msg, glow_msg = {}, {}, {}, {}, {}, {}
    for faction, *_ in factions:
        grid_msg[faction] = write_messages((side, faction, "Grid"), f"DocCreaturesGrid{side}{faction}")
        glows_msg[faction] = write_messages((side, faction, "Glows"), f"DocCreaturesGlows{side}{faction}")
        column_msg[faction] = write_messages((side, faction, "Column"), f"DocCreaturesColumn{side}{faction}")
        faction_sel_msg[faction] = write_messages((side, "Factions", f"{faction}Sel"), f"DocCreaturesFactionSel{side}{faction}")
        for creature in creatures[faction]:
            creature_id = creature['id']
            stats_msg[creature_id] = write_messages((side, faction, creature_id, "Stats"), f"DocCreaturesStats{side}{creature_id}")
            glow_msg[creature_id] = write_messages((side, faction, creature_id, "Glow"), f"DocCreaturesGlow{side}{creature_id}")

    # Faction buttons: show the faction's grid and the glow behind the button, hide the other factions' ones
    glows, buttons = [], []
    for idx, (faction, _, _, name_ref) in enumerate(factions):
        x = idx * faction_button_step
        glow_size = faction_button_size + 2 * selection_padding
        glows.append(write_window((side, "Factions", f"{faction}Sel"), f"DocCreaturesFactionSel{side}{faction}", faction == default_faction,
                                  (x, 0, glow_size, glow_size), background=selection_glow, priority=glow_priority))
        commands = ([grid_msg[faction][0]] + [grid_msg[o][1] for o in others(faction)]
                    + [faction_sel_msg[faction][0]] + [faction_sel_msg[o][1] for o in others(faction)])
        buttons.append(write_click_button((side, "Factions", faction), f"DocCreaturesFaction{side}{faction}", (x + selection_padding, selection_padding),
                                          faction_button_size, doc_path("_Factions", f"{faction}.(WindowMSButtonShared).xdb"), commands, tooltip=name_ref))
    row_box = (faction_button_x - selection_padding, faction_button_y - selection_padding,
               (len(factions) - 1) * faction_button_step + faction_button_size + 2 * selection_padding, faction_button_size + 2 * selection_padding)
    windows = [write_window((side, "Factions", "Factions"), f"DocCreaturesFactions{side}", side == default_side, row_box, glows + buttons, priority=button_priority)]

    # Per faction: the glows behind the grid cells, the grid, and the stat columns of its creatures. Clicking a creature
    # shows its stats and its glow, and hides the other creatures' ones (those of the faction, and the other factions'
    # columns and glows, which keep their last selection)
    for faction, *_ in factions:
        members = creatures[faction]
        cell_glows, cells, columns = [], [], []
        for idx, creature in enumerate(members):
            creature_id = creature['id']
            row, col = divmod(idx, grid_columns)
            x, y = col * cell_step[0], row * cell_step[1]
            cell_glows.append(write_window((side, faction, creature_id, "Glow"), f"DocCreaturesGlow{side}{creature_id}", False,
                                           (x - selection_padding, y - selection_padding, cell_size + 2 * selection_padding, cell_size + 2 * selection_padding),
                                           background=selection_glow, priority=glow_priority))
            cells.append(child(doc_path("_Frames", f"Cell{idx}.(WindowSimple).xdb"), "WindowSimple"))
            siblings = [c['id'] for c in members if c['id'] != creature_id]
            commands = ([stats_msg[creature_id][0]] + [stats_msg[s][1] for s in siblings]
                        + [column_msg[faction][0]] + [column_msg[o][1] for o in others(faction)]
                        + [glow_msg[creature_id][0]] + [glow_msg[s][1] for s in siblings]
                        + [glows_msg[faction][0]] + [glows_msg[o][1] for o in others(faction)])
            offset = (cell_size - cell_icon_size) // 2
            cells.append(write_click_button((side, faction, creature_id, "Button"), f"DocCreaturesButton{side}{creature_id}", (x + offset, y + offset),
                                            cell_icon_size, doc_path("_Creatures", f"{creature_id}.(WindowMSButtonShared).xdb"), commands,
                                            tooltip=creature['name']))
            columns.append(write_window((side, faction, creature_id, "Stats"), f"DocCreaturesStats{side}{creature_id}", False,
                                        (0, 0, column_width, column_height), shared=stats_shared[creature_id][side], priority=column_priority))
        box = (grid_x[side], grid_y, grid_width, grid_height)
        windows.append(write_window((side, faction, "Glows"), f"DocCreaturesGlows{side}{faction}", True, box, cell_glows, priority=glow_priority))
        windows.append(write_window((side, faction, "Grid"), f"DocCreaturesGrid{side}{faction}", faction == default_faction, box, cells, priority=grid_priority))
        windows.append(write_window((side, faction, "Column"), f"DocCreaturesColumn{side}{faction}", True,
                                    (column_x[side], column_top, column_width, column_height), columns, priority=column_priority))
    return windows


print("Generating Creatures UI...")
creatures = get_creatures()
for faction, members in creatures.items():
    print(f"  {faction}: {len(members)} creatures")

# Shared by both sides: the faction buttons, the grid buttons and their cell frames, and the stats of each creature
for faction, _, texture, _ in factions:
    write_button_shared(("_Factions", faction), f"/UI/Doc/Common/{texture}.(BackgroundSimpleScallingTexture).xdb")
stats_shared = {}
for members in creatures.values():
    for creature in members:
        creature_id = creature['id']
        write_button_shared(("_Creatures", creature_id), write_background(("_Creatures", creature_id), creature['icon'], 128))
        stats_shared[creature_id] = generate_stats(creature)
for idx in range(grid_columns * grid_rows):
    row, col = divmod(idx, grid_columns)
    write_window(("_Frames", f"Cell{idx}"), f"DocCreaturesCell{idx}", True, (col * cell_step[0], row * cell_step[1], cell_size, cell_size),
                 shared=doc_path("Common", "Creature_back.(WindowSimpleShared).xdb"))

children = [generate_panel()] + generate_side_buttons()
for side in sides:
    children += generate_side(side, creatures, stats_shared)
gen.write("window.(WindowSimpleShared).xdb.j2", out_path("Creatures.(WindowSimpleShared).xdb"),
          {'children': children, 'background': "/UI/Doc/Common/Background.(BackgroundSimpleScallingTexture).xdb", 'w': 1024, 'h': 1024})

gen.prune_unwritten(creatures_pedia_path, hand_made)
print(f"\nDone: {gen.written} files {'rendered (dry run)' if gen.dry_run else 'written'}")
