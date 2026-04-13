# Heroes 5 Mod: In-Game UI Creation Guide

## Overview
In-game UI for the Heroes 5 Tribes of the East mod is generated from **data files** (heroes, creatures, skills, spells) using **Python generator scripts** and **Jinja2 templates**. The final UI elements are stored as **.xdb files** (XML format) organized in the `game_data/www*` folders and synced to the game using PowerShell scripts.

---

## Architecture

### 1. **Data Sources**
The generators extract information from game mechanics data:
- **Heroes**: `game_data/heroes/MapObjects/*.xdb` (hero definitions)
- **Skills**: `game_data/skills/GameMechanics/RefTables/Skills.xdb`
- **Creatures**: `game_data/creatures/GameMechanics/RefTables/Creatures.xdb`
- **Spells**: `game_data/spells/GameMechanics/RefTables/UndividedSpells.xdb`
- **Classes**: `game_data/heroes/GameMechanics/RefTables/HeroClass.xdb`
- **Lua Scripts**: `game_data/lua/scripts/` (for hero armies and configuration)

### 2. **Text References**
Game UI displays text via external text file references:
- English texts: `game_texts/texts-EN/` (source of truth)
- Translated texts: `game_texts/texts-PL/`, `texts-FR/`, `texts-RU/`
- Number texts: `game_data/www/UI/Doc/Common/N/` (for creature counts)

### 3. **Output Structure**
Generated UI files are organized as:
```
game_data/www-heroes/UI/Doc/Heroes/
├── [Faction]/
│   └── [HeroID]/
│       ├── [HeroID].(WindowSimple).xdb
│       ├── [HeroID].(WindowSimpleShared).xdb
│       ├── [HeroID].(WindowMSButton).xdb
│       ├── [HeroID].(WindowMSButtonShared).xdb
│       ├── [HeroID].(BackgroundSimpleScallingTexture).xdb
│       ├── SwitchOn.(UISSendUIMessage).xdb
│       ├── SwitchOff.(UISSendUIMessage).xdb
│       ├── class/
│       │   ├── [HeroID]_class.(WindowSimple).xdb
│       │   ├── [HeroID]_class.(WindowSimpleShared).xdb
│       │   ├── [HeroID]_name.(WindowTextView).xdb
│       │   ├── [HeroID]_class.(WindowTextView).xdb
│       │   └── [HeroID]_stat*.(WindowSimple/TextView).xdb
│       ├── army/
│       │   ├── [HeroID]_army.(WindowSimple).xdb
│       │   ├── [HeroID]_army.(WindowSimpleShared).xdb
│       │   ├── [HeroID]_face.(WindowSimple/Shared).xdb
│       │   └── [HeroID]_cr[N].(WindowSimple).xdb (for each creature)
│       ├── spec/
│       ├── skills/
│       └── spells/
├── _Buttons/
├── _Creatures/
├── _Skills/
├── _Spells/
└── Common/
    └── N/ (numbers)
```

---

## 2 Main UI Generation Workflows

### A. Heroes UI (`generate-heroes-ui.py`)

**Process:**
1. **Parse hero data** from `game_data/heroes/MapObjects/[Faction]/*.xdb`
2. **Extract for each hero:**
   - Hero ID, name file reference, class, face texture
   - Starting army (from `starting-armies.lua`)
   - Skills and perks (with mastery levels)
   - Spells
   - Stats (Offence, Defence, SpellPower, Knowledge)
3. **Generate UI files** for each hero:
   - **Main button**: Hero button in heroes list (file: `herobutton.*.j2` templates)
   - **Main window**: Hero detail window (file: `herowindow.*.j2` templates)
   - **Class tab**: Hero class info with stats (multiple stat windows)
   - **Army tab**: Starting creatures display (hero_army, face, creature slots)
   - **Spec tab**: Specialization text display
   - **Skills tab**: Skills and perks icons/windows
   - **Spells tab**: Spells icons/windows
4. **Link resources:**
   - Icon textures (skills, creatures, spells)
   - Text file references
   - Background textures for buttons and icons

**Key Logic:**
- **Position calculation**: Heroes get sequential X positions in button bar
- **Icon sizing**: Different skills/perks have different icon sizes (64x64 or 128x128)
- **Creature slots**: Up to 5 creatures from starting army, + optional war machines
- **Stat display**: Stats positioned at calculated offsets (0, 80, 160, 240 px)

**Template System:**
- Uses Jinja2 templates from `tools/generators/templates-heroes/`
- Templates are XML structures with template variables: `{{ variable_name }}`
- Each template file name follows pattern: `[component].[XDBType].xdb.j2`

### B. Skills UI (`generate-skills-ui.py`)

**Process:**
1. **Read all skills** from `game_data/skills/GameMechanics/RefTables/Skills.xdb`
2. **For each skill branch:**
   - Define button grid coordinates (branch position)
   - Define skill position within branch
3. **Generate UI files:**
   - Branch windows (skill tree branches)
   - Skill buttons (with coordinates)
   - Skill icons and backgrounds
   - Selection highlights
   - Description view panels
4. **Create aggregated outputs:**
   - `outputs/skills_skillbuttons.xml` (all skill buttons)
   - `outputs/skills_selectionhighlights.xml` (selection visuals)
   - `outputs/skills_descriptionviews.xml` (descriptions)

**Key Data:**
- **Branches**: Organized skill categories (Logistics, Warfare, Combat, etc.)
- **Coordinates**: Fixed grid positions for each branch and skill within
- **Icon sizes**: Skill icons typically 34x34 px

**Output Paths:**
```
game_data/www-skills/UI/Doc/Skills/
```

---

## XDB File Types (Game UI Components)

| Type | Purpose | Example |
|------|---------|---------|
| `WindowSimple` | Main window container | hero detail window |
| `WindowSimpleShared` | Shared properties for windows | positioning, size |
| `WindowMSButton` | Multi-state button (mouse states) | hero button in list |
| `WindowMSButtonShared` | Shared button properties | tooltip, styling |
| `WindowTextView` | Text display container | hero name, class name |
| `ForegroundTextString` | Text string value | creature count display |
| `BackgroundSimpleScallingTexture` | Texture/image background | hero face, icon |
| `UISSendUIMessage` | UI message/event trigger | switch on/off windows |

---

## Template Pattern

All .xdb files are generated from Jinja2 templates:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<WindowMSButton ObjectRecordID="1000123">
  <ClassTypeID>285694855</ClassTypeID>
  <Shared href="{{ component_id }}.(WindowMSButtonShared).xdb#xpointer(/WindowMSButtonShared)"/>
  <Name>Button{{ component_id }}</Name>
  <TooltipFileRef href="{{ name_ref }}"/>
  <Visible>true</Visible>
  <Priority>0</Priority>
  <Placement>
    <Position>
      <First>
        <x>{{ x_pos }}</x>
        <y>{{ y_pos }}</y>
      </First>
      ...
    </Position>
    ...
  </Placement>
  ...
</WindowMSButton>
```

**Template variables** are passed as Python dict:
```python
write_from_template(
  "template_file.j2",
  "output_path.xdb",
  {'hero': 'Alaric', 'pos': 0, 'name_ref': '/Text/Heroes/Alaric.txt'}
)
```

---

## How Data Flows

```
Game Mechanics Data (XDB)
        ↓
Python Generator Script
  ├─ Parse XDB files
  ├─ Extract hero/skill/creature/spell info
  ├─ Calculate positions/layouts
  └─ Prepare context dicts
        ↓
Jinja2 Template Engine
  ├─ Load .j2 template files
  ├─ Render with context variables
  └─ Generate final XML
        ↓
Output XDB Files
  └─ Organized in www* folders
        ↓
PowerShell Sync Scripts
  ├─ tools/sync-heroes-ui.ps1
  ├─ tools/sync-skills-ui.ps1
  └─ Package as .pak (ZIP) → Game data folder
```

---

## Key Concepts for UI Creation

1. **Shared References**: UI components reference a "Shared" file for common properties
   - Reduces duplication
   - Allows centralized styling/behavior changes

2. **Hierarchical Windows**: UI elements nest within parent windows
   - Main window contains text views, buttons, images
   - Each sub-element has relative positioning/sizing

3. **Text File References**: UI doesn't embed text strings
   - References point to `game_texts` .txt files
   - Enables multi-language support and dynamic updates

4. **Icon Management**: Icons are managed separately
   - Stored in core game data (creatures, skills, spells)
   - Generator links them via texture paths
   - Can be resized (64x64, 128x128, 34x34, etc.)

5. **Grid Positioning**: Elements positioned in pixel grids
   - Buttons in lists use sequential X offsets
   - Skill tree uses calculated branch + skill positions
   - Creatures array uses fixed slot positions

---

## Running the Generators

From `tools/generators/` directory:

```bash
# Generate hero UI
python generate-heroes-ui.py

# Generate skills UI  
python generate-skills-ui.py
```

Then sync to game:
```powershell
# PowerShell from tools/ folder
./sync-heroes.ps1
./sync-skills.ps1
```

---

## Summary: Steps to Create Custom UI

1. **Define data** in game mechanics files (hero .xdb, skills .xdb, etc.)
2. **Update generator script** if new UI sections needed
3. **Create Jinja2 templates** for new component types
4. **Add context variables** in generator (extract needed data)
5. **Run generator** to produce .xdb files
6. **Sync to game** via PowerShell script
7. **Test in-game** to verify appearance/functionality
