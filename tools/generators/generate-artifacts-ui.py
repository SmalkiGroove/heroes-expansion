import os
import xmltodict
from jinja2 import Environment, FileSystemLoader
from collections import defaultdict

debug = True
dry_run = False

artifacts_xdb_path = "../../game_data/artifacts/GameMechanics/RefTables/Artifacts.xdb"
defaultstats_xdb_path = "../../game_data/core/GameMechanics/RPGStats/DefaultStats.xdb"
artifacts_pedia_path = "../../game_data/www-artifacts/UI/Doc/Artifacts"

jinja_env = Environment(loader=FileSystemLoader(searchpath="templates-artifacts"))

# Load data files
with open(artifacts_xdb_path, 'r') as artifacts_file:
    artifacts_data = xmltodict.parse(artifacts_file.read())
with open(defaultstats_xdb_path, 'r') as stats_file:
    stats_data = xmltodict.parse(stats_file.read())

# Artifact classes
artf_classes = {
    "ARTF_CLASS_MINOR": "Minor",
    "ARTF_CLASS_MAJOR": "Major",
    "ARTF_CLASS_RELIC": "Relic",
}

# Artifact slots - friendly names
slot_names = {
    "PRIMARY": "Right hand",
    "SECONDARY": "Left hand",
    "HEAD": "Head",
    "SHOULDERS": "Shoulders",
    "CHEST": "Chest",
    "FEET": "Feet",
    "NECK": "Neck",
    "FINGER": "Ring",
    "MISCSLOT1": "Pocket",
    "INVENTORY": "Backpack",
}

def write_from_template(tpl_name, output_path, variables):
    """Render template and write to file"""
    tpl = jinja_env.get_template(tpl_name)
    rendered = tpl.render(variables)
    if not dry_run:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, 'w') as out_file:
            out_file.write(rendered)

def log(msg):
    if debug:
        print(msg)

def get_artifacts_list():
    """Extract all artifacts from the artifact table"""
    artifacts = []
    artifact_items = artifacts_data['Table_DBArtifact_ArtifactEffect']['objects']['Item']
    if not isinstance(artifact_items, list):
        artifact_items = [artifact_items]
    
    for item in artifact_items:
        artifact_id = item['ID']
        obj = item['obj']
        
        # Skip ARTIFACT_NONE
        if obj.get('Slot', 'INVENTORY') == "INVENTORY":
            continue
        
        log(f"Load artifact {artifact_id}...")
        name_ref = obj.get('NameFileRef', {}).get('@href', '')
        desc_ref = obj.get('DescriptionFileRef', {}).get('@href', '')
        icon = obj.get('Icon', {})
        icon_href = icon.get('@href', '') if isinstance(icon, dict) else ''
        artf_type = obj.get('Type', 'ARTF_CLASS_MINOR')
        slot = obj.get('Slot', 'INVENTORY')
        gold_cost = obj.get('CostOfGold', 0)
        
        artifacts.append({
            'id': artifact_id,
            'name_ref': name_ref,
            'desc_ref': desc_ref,
            'icon_href': icon_href,
            'type': artf_type,
            'slot': slot,
            'gold_cost': gold_cost,
        })
    
    return artifacts

def get_artifact_sets():
    """Extract artifact sets from DefaultStats"""
    sets = []
    artifact_sets = stats_data['RPGStats']['ArtifactSets']['Sets']['Item']
    if not isinstance(artifact_sets, list):
        artifact_sets = [artifact_sets]
    
    for artf_set in artifact_sets:
        if artf_set.get('NameFileRef', {}) == None:
            continue
        
        log(f"Load artifact set {artf_set.get('Effect', '')}...")
        effect = artf_set.get('Effect', '')
        name_ref = artf_set.get('NameFileRef', {}).get('@href', '')
        desc_ref = artf_set.get('DescriptionFileRef', {}).get('@href', '')
        
        artifacts_in_set = []
        set_artifacts = artf_set.get('Artifacts', {}).get('Item', [])
        if not isinstance(set_artifacts, list):
            set_artifacts = [set_artifacts]
        
        for artifact_entry in set_artifacts:
            artifacts_in_set.append(artifact_entry.get('Artifact', ''))
        
        sets.append({
            'effect': effect,
            'name_ref': name_ref,
            'desc_ref': desc_ref,
            'artifacts': artifacts_in_set,
        })
    
    return sets

def group_artifacts_by_class(artifacts):
    """Group artifacts by their class (Minor, Major, Relic)"""
    grouped = defaultdict(list)
    for artifact in artifacts:
        artf_class = artifact['type']
        grouped[artf_class].append(artifact)
    return grouped

def group_artifacts_by_slot(artifacts):
    """Group artifacts by their slot"""
    grouped = defaultdict(list)
    for artifact in artifacts:
        slot = artifact['slot']
        grouped[slot].append(artifact)
    return grouped

def group_artifacts_by_set(artifacts, sets):
    """Group artifacts by their set membership"""
    set_map = {}
    for artf_set in sets:
        for artifact_id in artf_set['artifacts']:
            if artifact_id not in set_map:
                set_map[artifact_id] = []
            set_map[artifact_id].append(artf_set)
    
    # Create set groups
    set_groups = defaultdict(list)
    for artifact in artifacts:
        if artifact['id'] in set_map:
            for artf_set in set_map[artifact['id']]:
                set_groups[artf_set['effect']].append(artifact)
    
    return set_groups

# Main generation
print("Generating Artifacts UI...")

# Load artifacts and sets
artifacts = get_artifacts_list()
artifact_sets = get_artifact_sets()

print(f"Found {len(artifacts)} artifacts")
print(f"Found {len(artifact_sets)} artifact sets")

# Create base output directory
os.makedirs(artifacts_pedia_path, exist_ok=True)

# Generate main view selector window
write_from_template(
    "window_main.(WindowSimple).xdb.j2",
    os.path.join(artifacts_pedia_path, "Artifacts.(WindowSimple).xdb"),
    {'views': ['ByClass', 'BySlot', 'BySet']}
)
write_from_template(
    "window_main.(WindowSimpleShared).xdb.j2",
    os.path.join(artifacts_pedia_path, "Artifacts.(WindowSimpleShared).xdb"),
    {'views': ['ByClass', 'BySlot', 'BySet']}
)

# Generate BY CLASS view
print("\nGenerating BY CLASS view...")
class_grouped = group_artifacts_by_class(artifacts)
os.makedirs(os.path.join(artifacts_pedia_path, "ByClass"), exist_ok=True)

for artf_class, items in sorted(class_grouped.items()):
    class_name = artf_classes.get(artf_class, artf_class)
    class_key = artf_class.replace("ARTF_CLASS_", "").lower()
    
    print(f"  {class_name}: {len(items)} artifacts")
    
    # Create category window
    write_from_template(
        "category_window.(WindowSimple).xdb.j2",
        os.path.join(artifacts_pedia_path, f"ByClass/{class_key}.(WindowSimple).xdb"),
        {
            'category_id': class_key,
            'artifacts': items,
            'category_type': 'class',
        }
    )
    artifact_ids = [a['id'] for a in items]
    write_from_template(
        "category_window.(WindowSimpleShared).xdb.j2",
        os.path.join(artifacts_pedia_path, f"ByClass/{class_key}.(WindowSimpleShared).xdb"),
        {
            'category_id': class_key,
            'num_artifacts': len(items),
            'artifact_ids': artifact_ids,
        }
    )
    
    # Create artifact windows for this category
    for idx, artifact in enumerate(items):
        row = idx // 5
        col = idx % 5
        x_pos = col * 70
        y_pos = row * 70
        
        write_from_template(
            "artifact_icon.(WindowSimple).xdb.j2",
            os.path.join(artifacts_pedia_path, f"ByClass/{class_key}/{artifact['id']}.(WindowSimple).xdb"),
            {
                'artifact_id': artifact['id'],
                'x_pos': x_pos,
                'y_pos': y_pos,
                'name_ref': artifact['name_ref'],
            }
        )
        write_from_template(
            "artifact_icon.(WindowSimpleShared).xdb.j2",
            os.path.join(artifacts_pedia_path, f"ByClass/{class_key}/{artifact['id']}.(WindowSimpleShared).xdb"),
            {
                'artifact_id': artifact['id'],
            }
        )
        write_from_template(
            "artifact_icon_bg.(BackgroundSimpleScallingTexture).xdb.j2",
            os.path.join(artifacts_pedia_path, f"ByClass/{class_key}/{artifact['id']}.(BackgroundSimpleScallingTexture).xdb"),
            {
                'icon_path': artifact['icon_href'],
                'size': 64,
            }
        )
        write_from_template(
            "artifact_tooltip.(WindowTextView).xdb.j2",
            os.path.join(artifacts_pedia_path, f"ByClass/{class_key}/{artifact['id']}_tooltip.(WindowTextView).xdb"),
            {
                'artifact_id': artifact['id'],
                'name_ref': artifact['name_ref'],
                'desc_ref': artifact['desc_ref'],
                'gold_cost': artifact['gold_cost'],
            }
        )

# Generate BY SLOT view
print("\nGenerating BY SLOT view...")
slot_grouped = group_artifacts_by_slot(artifacts)
os.makedirs(os.path.join(artifacts_pedia_path, "BySlot"), exist_ok=True)

for slot, items in sorted(slot_grouped.items()):
    slot_friendly = slot_names.get(slot, slot)
    slot_key = slot.lower()
    
    print(f"  {slot_friendly}: {len(items)} artifacts")
    
    # Create category window
    write_from_template(
        "category_window.(WindowSimple).xdb.j2",
        os.path.join(artifacts_pedia_path, f"BySlot/{slot_key}.(WindowSimple).xdb"),
        {
            'category_id': slot_key,
            'artifacts': items,
            'category_type': 'slot',
        }
    )
    artifact_ids = [a['id'] for a in items]
    write_from_template(
        "category_window.(WindowSimpleShared).xdb.j2",
        os.path.join(artifacts_pedia_path, f"BySlot/{slot_key}.(WindowSimpleShared).xdb"),
        {
            'category_id': slot_key,
            'num_artifacts': len(items),
            'artifact_ids': artifact_ids,
        }
    )
    
    # Create artifact windows for this category
    for idx, artifact in enumerate(items):
        row = idx // 5
        col = idx % 5
        x_pos = col * 70
        y_pos = row * 70
        
        write_from_template(
            "artifact_icon.(WindowSimple).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySlot/{slot_key}/{artifact['id']}.(WindowSimple).xdb"),
            {
                'artifact_id': artifact['id'],
                'x_pos': x_pos,
                'y_pos': y_pos,
                'name_ref': artifact['name_ref'],
            }
        )
        write_from_template(
            "artifact_icon.(WindowSimpleShared).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySlot/{slot_key}/{artifact['id']}.(WindowSimpleShared).xdb"),
            {
                'artifact_id': artifact['id'],
            }
        )
        write_from_template(
            "artifact_icon_bg.(BackgroundSimpleScallingTexture).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySlot/{slot_key}/{artifact['id']}.(BackgroundSimpleScallingTexture).xdb"),
            {
                'icon_path': artifact['icon_href'],
                'size': 64,
            }
        )
        write_from_template(
            "artifact_tooltip.(WindowTextView).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySlot/{slot_key}/{artifact['id']}_tooltip.(WindowTextView).xdb"),
            {
                'artifact_id': artifact['id'],
                'name_ref': artifact['name_ref'],
                'desc_ref': artifact['desc_ref'],
                'gold_cost': artifact['gold_cost'],
            }
        )

# Generate BY SET view
print("\nGenerating BY SET view...")
set_grouped = group_artifacts_by_set(artifacts, artifact_sets)
os.makedirs(os.path.join(artifacts_pedia_path, "BySet"), exist_ok=True)

for set_effect, items in sorted(set_grouped.items()):
    set_key = set_effect.lower()
    
    print(f"  {set_effect}: {len(items)} artifacts")
    
    # Create category window
    write_from_template(
        "category_window.(WindowSimple).xdb.j2",
        os.path.join(artifacts_pedia_path, f"BySet/{set_key}.(WindowSimple).xdb"),
        {
            'category_id': set_key,
            'artifacts': items,
            'category_type': 'set',
        }
    )
    artifact_ids = [a['id'] for a in items]
    write_from_template(
        "category_window.(WindowSimpleShared).xdb.j2",
        os.path.join(artifacts_pedia_path, f"BySet/{set_key}.(WindowSimpleShared).xdb"),
        {
            'category_id': set_key,
            'num_artifacts': len(items),
            'artifact_ids': artifact_ids,
        }
    )
    
    # Create artifact windows for this category
    for idx, artifact in enumerate(items):
        row = idx // 5
        col = idx % 5
        x_pos = col * 70
        y_pos = row * 70
        
        write_from_template(
            "artifact_icon.(WindowSimple).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySet/{set_key}/{artifact['id']}.(WindowSimple).xdb"),
            {
                'artifact_id': artifact['id'],
                'x_pos': x_pos,
                'y_pos': y_pos,
                'name_ref': artifact['name_ref'],
            }
        )
        write_from_template(
            "artifact_icon.(WindowSimpleShared).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySet/{set_key}/{artifact['id']}.(WindowSimpleShared).xdb"),
            {
                'artifact_id': artifact['id'],
            }
        )
        write_from_template(
            "artifact_icon_bg.(BackgroundSimpleScallingTexture).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySet/{set_key}/{artifact['id']}.(BackgroundSimpleScallingTexture).xdb"),
            {
                'icon_path': artifact['icon_href'],
                'size': 64,
            }
        )
        write_from_template(
            "artifact_tooltip.(WindowTextView).xdb.j2",
            os.path.join(artifacts_pedia_path, f"BySet/{set_key}/{artifact['id']}_tooltip.(WindowTextView).xdb"),
            {
                'artifact_id': artifact['id'],
                'name_ref': artifact['name_ref'],
                'desc_ref': artifact['desc_ref'],
                'gold_cost': artifact['gold_cost'],
            }
        )

print("\n✓ Artifacts UI generation complete!")
