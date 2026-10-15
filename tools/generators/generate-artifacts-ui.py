"""Generates the Artifacts tab of the encyclopedia (game_data/www-artifacts/UI/Doc/Artifacts).

The equipable artifacts are shown in three views (ByClass, BySlot, BySet). A view button shows its view window, which
holds one button per class, slot or set. A category button shows its category window: a grid of artifact icons, plus
the bonuses for a set. Hovering an icon shows the artifact description on the right.
Hand-made: the Artifacts.(WindowSimple) instance, _Buttons/ and Common/. Every other file is generated, and stale
files are removed.
"""

import os
from collections import defaultdict
from common import Generator, GAME_DATA, warn, load_xdb, as_list, game_path, texture_size

gen = Generator("templates-artifacts", __doc__)

artifacts_pedia_path = os.path.join(GAME_DATA, "www-artifacts", "UI", "Doc", "Artifacts")
artifacts_data = load_xdb(GAME_DATA, "artifacts", "GameMechanics", "RefTables", "Artifacts.xdb")
stats_data = load_xdb(GAME_DATA, "core", "GameMechanics", "RPGStats", "DefaultStats.xdb")

# Hand-made files of the tab, relative to artifacts_pedia_path
hand_made = ("Artifacts.(WindowSimple).xdb", "_Buttons/", "Common/")

# Views, with the UI-local label of their button
views = {'ByClass': "By class", 'BySlot': "By slot", 'BySet': "By set"}
# Classes in display order, with their UI-local label
class_labels = {'ARTF_CLASS_MINOR': "Minor", 'ARTF_CLASS_MAJOR': "Major", 'ARTF_CLASS_RELIC': "Relic", 'ARTF_CLASS_GRAIL': "Grail"}
# Slots in display order, with the vanilla hero screen text naming them
slot_texts = {
    'PRIMARY': "/UI/HeroScreen3/Inventory/Weapon.txt",
    'SECONDARY': "/UI/HeroScreen3/Inventory/Shield.txt",
    'HEAD': "/UI/HeroScreen3/Inventory/Helm.txt",
    'CHEST': "/UI/HeroScreen3/Inventory/Cirase.txt",
    'SHOULDERS': "/UI/HeroScreen3/Inventory/Cloak.txt",
    'NECK': "/UI/HeroScreen3/Inventory/Necklace.txt",
    'FINGER': "/UI/HeroScreen3/Inventory/Ring.txt",
    'FEET': "/UI/HeroScreen3/Inventory/Boots.txt",
    'MISCSLOT1': "/UI/HeroScreen3/Inventory/Additional.txt",
}

# Layout, in pixels of the Artifacts window (1024x1024, its parchment ends at y=690)
view_button_x, view_button_y, view_button_step = 60, 55, 170
view_button_size = (160, 32)
view_window_x, view_window_y = 40, 100
view_window_size = (940, 590)
category_columns = 5
category_button_size = (180, 26)
category_button_step = (186, 28)
# Icons grid of a category window: the largest (step, icon size) that fits wins
grid_width = 600
grid_sizes = [(70, 64), (62, 56), (54, 48), (48, 44), (42, 38)]
# Set bonuses panel, below one row of icons
set_panel_y = 80
set_panel_size = (600, 300)
set_back_size = (1041, 531)  # HeroSpecBack draws its frame on the top-left 57.6% x 56.4% of its texture
# Artifact description, at the same place as the skills description
description_back = (655, 250, 305, 600)
description_pos = (690, 310)
description_size = (200, 400)
# Button groups: selecting a button releases the other buttons of its group
view_group = 20
category_group = 21


def out_path(*parts):
    return os.path.join(artifacts_pedia_path, *parts)

def doc_path(*parts):
    """In-game path of a file of the tab."""
    return game_path("UI/Doc/Artifacts", *parts)

def child(href, ui_type):
    return {'href': href, 'type': ui_type}

def write_window(path, name, visible, x, y, w, h, children=(), background=None):
    """A WindowSimple instance and its own Shared file."""
    shared = path.replace("(WindowSimple)", "(WindowSimpleShared)")
    gen.write("window.(WindowSimple).xdb.j2", path, {'name': name, 'shared': os.path.basename(shared), 'visible': visible, 'x': x, 'y': y, 'w': w, 'h': h})
    gen.write("window.(WindowSimpleShared).xdb.j2", shared, {'children': children, 'background': background, 'w': w, 'h': h})

def write_text_button(folder, name, window, text_ref, x, y, size, group):
    """A toggle button showing a window (Button + SwitchOn/SwitchOff in folder)."""
    w, h = size
    gen.write("textbutton.(WindowMSButton).xdb.j2", os.path.join(folder, "Button.(WindowMSButton).xdb"),
              {'name': name, 'text_ref': text_ref, 'x': x, 'y': y, 'w': w, 'h': h, 'group': group})
    gen.write("textbutton.(WindowMSButtonShared).xdb.j2", os.path.join(folder, "Button.(WindowMSButtonShared).xdb"), {'w': w, 'h': h})
    gen.write("switch.(UISSendUIMessage).xdb.j2", os.path.join(folder, "SwitchOn.(UISSendUIMessage).xdb"), {'window': window, 'open': 1, 'close': 0})
    gen.write("switch.(UISSendUIMessage).xdb.j2", os.path.join(folder, "SwitchOff.(UISSendUIMessage).xdb"), {'window': window, 'open': 0, 'close': 1})

def write_text_view(path, name, text_ref, text_format, x, y, w, h):
    gen.write("textview.(WindowTextView).xdb.j2", path, {'name': name, 'text_ref': text_ref, 'format': text_format, 'x': x, 'y': y, 'w': w, 'h': h})


def get_artifacts_list():
    """Every artifact that can be equipped and has an icon, in table order."""
    artifacts = []
    for item in as_list(artifacts_data['Table_DBArtifact_ArtifactEffect']['objects']['Item']):
        obj = item['obj']
        # Skips ARTIFACT_NONE and backpack-only items
        if obj.get('Slot', 'INVENTORY') == "INVENTORY":
            continue
        icon = (obj.get('Icon') or {}).get('@href', '')
        if not icon:
            warn(f"artifact {item['ID']} has no icon")
            continue
        gen.log(f"Load artifact {item['ID']}...")
        artifacts.append({
            'id': item['ID'],
            'name_ref': (obj.get('NameFileRef') or {}).get('@href', ''),
            'desc_ref': (obj.get('DescriptionFileRef') or {}).get('@href', ''),
            'icon_href': icon,
            'type': obj.get('Type', 'ARTF_CLASS_MINOR'),
            'slot': obj['Slot'],
        })
    return artifacts

def get_artifact_sets():
    """Named artifact sets of DefaultStats, in table order."""
    sets = []
    for artf_set in as_list(stats_data['RPGStats']['ArtifactSets']['Sets']['Item']):
        if artf_set.get('NameFileRef') is None:
            continue
        gen.log(f"Load artifact set {artf_set['Effect']}...")
        # Bonus texts are indexed by the number of pieces minus one; a tier starts where the text changes
        tiers = []
        for idx, ref in enumerate(as_list((artf_set.get('CombinedDescriptionsFileRefs') or {}).get('Item'))):
            href = (ref or {}).get('@href', '')
            if href and (not tiers or tiers[-1]['ref'] != href):
                tiers.append({'pieces': idx + 1, 'ref': href})
        sets.append({
            'effect': artf_set['Effect'],
            'name_ref': artf_set['NameFileRef']['@href'],
            'desc_ref': (artf_set.get('DescriptionFileRef') or {}).get('@href', ''),
            'artifacts': [entry['Artifact'] for entry in as_list((artf_set.get('Artifacts') or {}).get('Item'))],
            'tiers': tiers,
        })
    return sets


def get_categories(artifacts, artifact_sets):
    """Categories of each view: {view: [{'id', 'label_ref', 'artifacts', 'set'}]}, in display order."""
    by_class = defaultdict(list)
    by_slot = defaultdict(list)
    for artifact in artifacts:
        by_class[artifact['type']].append(artifact)
        by_slot[artifact['slot']].append(artifact)
    for artf_class in by_class.keys() - class_labels.keys():
        warn(f"unknown artifact class {artf_class}, its artifacts are not shown by class")
    for slot in by_slot.keys() - slot_texts.keys():
        warn(f"unknown artifact slot {slot}, its artifacts are not shown by slot")

    categories = {view: [] for view in views}
    for artf_class, label in class_labels.items():
        if by_class[artf_class]:
            category_id = artf_class.replace("ARTF_CLASS_", "").capitalize()
            label_ref = doc_path("ByClass", category_id, "Name.txt")
            gen.write_text(out_path("ByClass", category_id, "Name.txt"), label)
            categories['ByClass'].append({'id': category_id, 'label_ref': label_ref, 'artifacts': by_class[artf_class]})
    for slot, label_ref in slot_texts.items():
        if by_slot[slot]:
            categories['BySlot'].append({'id': slot.capitalize(), 'label_ref': label_ref, 'artifacts': by_slot[slot]})
    by_id = {artifact['id']: artifact for artifact in artifacts}
    for artf_set in artifact_sets:
        missing = [a for a in artf_set['artifacts'] if a not in by_id]
        if missing:
            warn(f"set {artf_set['effect']} contains unknown or non-equipable artifacts {missing}")
        categories['BySet'].append({'id': artf_set['effect'].replace("ARTFSET_", ""), 'label_ref': artf_set['name_ref'],
                                    'artifacts': [by_id[a] for a in artf_set['artifacts'] if a in by_id], 'set': artf_set})
    return categories


def grid_layout(count, height):
    """(step, icon size, columns) of the largest icons that fit count icons in grid_width x height."""
    for step, size in grid_sizes:
        columns = grid_width // step
        if (count + columns - 1) // columns * step <= height:
            return step, size, columns
    warn(f"{count} icons don't fit in {grid_width}x{height}")
    return grid_sizes[-1] + (grid_width // grid_sizes[-1][0],)


def generate_set_panel(category_id, artf_set):
    """Set bonuses below the icons: name, description, then one column per bonus tier."""
    folder = out_path("BySet", category_id)
    name = f"DocArtifactsSet{category_id}"
    w, h = set_panel_size
    gen.write("window.(WindowSimple).xdb.j2", os.path.join(folder, "Back.(WindowSimple).xdb"),
              {'name': f"{name}Back", 'shared': doc_path("BySet", "SetBack.(WindowSimpleShared).xdb"), 'visible': True,
               'x': 0, 'y': 0, 'w': set_back_size[0], 'h': set_back_size[1]})
    write_text_view(os.path.join(folder, "Title.(WindowTextView).xdb"), f"{name}Title", artf_set['name_ref'], "SetTitle", 15, 12, w - 30, 30)
    children = [child("Back.(WindowSimple).xdb", "WindowSimple"), child("Title.(WindowTextView).xdb", "WindowTextView")]
    if artf_set['desc_ref']:
        write_text_view(os.path.join(folder, "Description.(WindowTextView).xdb"), f"{name}Description", artf_set['desc_ref'], "SetDescription", 15, 42, w - 30, 22)
        children.append(child("Description.(WindowTextView).xdb", "WindowTextView"))
    column_width = (w - 30) // max(len(artf_set['tiers']), 1)
    for idx, tier in enumerate(artf_set['tiers']):
        pieces = tier['pieces']
        x = 15 + idx * column_width
        write_text_view(os.path.join(folder, f"Label{pieces}.(WindowTextView).xdb"), f"{name}Label{pieces}", doc_path("BySet", f"Pieces{pieces}.txt"), "SetLabel", x, 72, column_width - 10, 24)
        write_text_view(os.path.join(folder, f"Bonus{pieces}.(WindowTextView).xdb"), f"{name}Bonus{pieces}", tier['ref'], "SetBonus", x, 98, column_width - 10, h - 110)
        children.append(child(f"Label{pieces}.(WindowTextView).xdb", "WindowTextView"))
        children.append(child(f"Bonus{pieces}.(WindowTextView).xdb", "WindowTextView"))
    write_window(os.path.join(folder, "Panel.(WindowSimple).xdb"), name, True, 0, set_panel_y, w, h, children)
    return {tier['pieces'] for tier in artf_set['tiers']}


def generate_view(view, view_idx, categories):
    """View button and window: one button per category, then the hidden category windows."""
    print(f"\nGenerating {view} view...")
    view_name = f"DocArtifacts{view}"
    gen.write_text(out_path(f"{view}Button", "Name.txt"), views[view])
    write_text_button(out_path(f"{view}Button"), f"DocArtifactsButton{view}", view_name, doc_path(f"{view}Button", "Name.txt"),
                      view_button_x + view_idx * view_button_step, view_button_y, view_button_size, view_group)

    rows = (len(categories) + category_columns - 1) // category_columns
    grid_top = rows * category_button_step[1] + 12
    view_w, view_h = view_window_size
    buttons, windows, pieces = [], [], set()
    for idx, category in enumerate(categories):
        category_id = category['id']
        items = category['artifacts']
        category_name = f"{view_name}{category_id}"
        print(f"  {category_id}: {len(items)} artifacts")
        write_text_button(out_path(view, category_id), f"DocArtifactsButton{view}{category_id}", category_name, category['label_ref'],
                          idx % category_columns * category_button_step[0], idx // category_columns * category_button_step[1],
                          category_button_size, category_group)
        buttons.append(child(f"{category_id}/Button.(WindowMSButton).xdb", "WindowMSButton"))

        grid_height = set_panel_y if 'set' in category else view_h - grid_top
        step, size, columns = grid_layout(len(items), grid_height)
        children = []
        for item_idx, artifact in enumerate(items):
            gen.write("artifact_button.(WindowMSButton).xdb.j2", out_path(view, category_id, f"{artifact['id']}.(WindowMSButton).xdb"),
                      {'view': view, 'artifact_id': artifact['id'], 'size': size,
                       'x': item_idx % columns * step, 'y': item_idx // columns * step})
            children.append(child(f"{category_id}/{artifact['id']}.(WindowMSButton).xdb", "WindowMSButton"))
        if 'set' in category:
            pieces |= generate_set_panel(category_id, category['set'])
            children.append(child(f"{category_id}/Panel.(WindowSimple).xdb", "WindowSimple"))
        write_window(out_path(view, f"{category_id}.(WindowSimple).xdb"), category_name, False, 0, grid_top, grid_width, view_h - grid_top, children)
        windows.append(child(f"{category_id}.(WindowSimple).xdb", "WindowSimple"))

    if any('set' in category for category in categories):
        gen.write("window.(WindowSimpleShared).xdb.j2", out_path(view, "SetBack.(WindowSimpleShared).xdb"),
                  {'background': "/UI/Doc/Heroes/Common/HeroSpecBack.(BackgroundSimpleScallingTexture).xdb", 'w': set_back_size[0], 'h': set_back_size[1]})
    for count in sorted(pieces):
        gen.write_text(out_path(view, f"Pieces{count}.txt"), f"{count} pieces")
    write_window(out_path(view, f"{view}.(WindowSimple).xdb"), view_name, False, view_window_x, view_window_y, view_w, view_h, buttons + windows)


def generate_description(artifact, artf_set):
    """Hidden description window, shown while the artifact icon is hovered."""
    artifact_id = artifact['id']
    folder = out_path("_Description", artifact_id)
    name = f"DocArtifactsDesc{artifact_id}"
    w, h = description_size
    gen.write("switch.(UISSendUIMessage).xdb.j2", os.path.join(folder, "Show.(UISSendUIMessage).xdb"), {'window': name, 'open': 1, 'close': 0})
    gen.write("artifact_icon.(WindowSimple).xdb.j2", os.path.join(folder, "Icon.(WindowSimple).xdb"), {'artifact_id': artifact_id, 'x': (w - 64) // 2, 'y': 0, 'size': 64})
    children = [child("Icon.(WindowSimple).xdb", "WindowSimple")]
    write_text_view(os.path.join(folder, "Name.(WindowTextView).xdb"), f"{name}Name", artifact['name_ref'], "Name", 0, 70, w, 40)
    write_text_view(os.path.join(folder, "Description.(WindowTextView).xdb"), f"{name}Description", artifact['desc_ref'], "Description", 0, 115, w, 230)
    children += [child("Name.(WindowTextView).xdb", "WindowTextView"), child("Description.(WindowTextView).xdb", "WindowTextView")]
    if artf_set:
        write_text_view(os.path.join(folder, "Set.(WindowTextView).xdb"), f"{name}Set", artf_set['name_ref'], "SetName", 0, 350, w, 40)
        children.append(child("Set.(WindowTextView).xdb", "WindowTextView"))
    write_window(os.path.join(folder, f"{artifact_id}.(WindowSimple).xdb"), name, False, 0, 0, w, h, children)


print("Generating Artifacts UI...")
artifacts = get_artifacts_list()
artifact_sets = get_artifact_sets()
print(f"Found {len(artifacts)} artifacts and {len(artifact_sets)} artifact sets")

# Icons and descriptions, shared by every view
set_of = {}
for artf_set in artifact_sets:
    for artifact_id in artf_set['artifacts']:
        set_of.setdefault(artifact_id, artf_set)
for artifact in artifacts:
    size = texture_size(artifact['icon_href'])
    icon_path = out_path("_Artifacts", artifact['id'])
    gen.write("artifact_icon.(WindowSimpleShared).xdb.j2", f"{icon_path}.(WindowSimpleShared).xdb", {'id': artifact['id'], 'size': size})
    gen.write("artifact_icon_bg.(BackgroundSimpleScallingTexture).xdb.j2", f"{icon_path}.(BackgroundSimpleScallingTexture).xdb", {'path': artifact['icon_href'], 'size': size})
    gen.write("artifact_button.(WindowMSButtonShared).xdb.j2", f"{icon_path}.(WindowMSButtonShared).xdb", {'artifact_id': artifact['id']})
    generate_description(artifact, set_of.get(artifact['id']))
write_window(out_path("_Description", "Descriptions.(WindowSimple).xdb"), "DocArtifactsDescriptions", True, *description_pos, *description_size,
             [child(f"{a['id']}/{a['id']}.(WindowSimple).xdb", "WindowSimple") for a in artifacts])
write_window(out_path("_Description", "Back.(WindowSimple).xdb"), "DocArtifactsDescriptionBack", True, *description_back,
             background="/UI/Doc/Skills/_Description/DescriptionBack.(BackgroundSimpleScallingTexture).xdb")

categories = get_categories(artifacts, artifact_sets)
for view_idx, view in enumerate(views):
    generate_view(view, view_idx, categories[view])

# Main window: view buttons, view windows, then the description panel on top
gen.write("window.(WindowSimpleShared).xdb.j2", out_path("Artifacts.(WindowSimpleShared).xdb"), {
    'children': [child(f"{view}Button/Button.(WindowMSButton).xdb", "WindowMSButton") for view in views]
              + [child(f"{view}/{view}.(WindowSimple).xdb", "WindowSimple") for view in views]
              + [child("_Description/Back.(WindowSimple).xdb", "WindowSimple"), child("_Description/Descriptions.(WindowSimple).xdb", "WindowSimple")],
    'background': "/UI/Doc/Common/Background.(BackgroundSimpleScallingTexture).xdb", 'w': 1024, 'h': 1024})

gen.prune_unwritten(artifacts_pedia_path, hand_made)
print(f"\nDone: {gen.written} files {'rendered (dry run)' if gen.dry_run else 'written'}")
