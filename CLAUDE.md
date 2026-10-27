# Heroes Expansion (H5X)

H5X is a mod for **Heroes of Might and Magic 5: Tribes of the East**. It changes heroes (two classes per faction), skills, creatures, artifacts and spells, adds custom mechanics in Lua, and includes an in-game encyclopedia. The current version is in `VERSION`. Player-facing notes are in `README.md`, `CHANGELOG.md` and `KNOWN_ISSUES.md`.

This file is the project's knowledge base. Each topic guide below has the details for one area. **Read the matching guide before working there, and update it, or this file, when you learn something non-obvious.**

| Topic | Guide | Covers |
|-------|-------|--------|
| In-game UI and encyclopedia | [.cursor/rules/ui.md](.cursor/rules/ui.md) | XDB UI anatomy, show/hide messages, buttons, encyclopedia structure, generators |
| Lua scripts | [.cursor/rules/lua.md](.cursor/rules/lua.md) | Lua 4.0 runtimes (adventure map and combat), entry points, engine functions |
| Texts | [.cursor/rules/text.md](.cursor/rules/text.md) | UTF-16 LE text files, formatting tags, translation |
| Random map templates | [.cursor/rules/rmg.md](.cursor/rules/rmg.md) | YAML template sources, generator and importer, meaning of the template fields |

`.github/copilot-instructions.md` and `.cursor/rules/` serve other assistants. Keep them consistent with this file.

For work on the game binary (reverse engineering `H5X.exe`, runtime patches, save files), refer to the DLL project `G:\__H5__\H5X_DLL` and its `CLAUDE.md`.

## Repository layout

| Folder | Content |
|--------|---------|
| `game_data/<folder>/` | Game data, the source of truth. Each folder becomes one pak, `h5x-<folder>.pak`. |
| `game_texts/texts-<LANG>/` | Texts. `texts-EN` is the source; the PL, FR and RU folders are machine-translated and **must not be edited**. |
| `tools/` | Sync scripts, release, translator, generators, debug scripts |
| `documentation/` | Markdown tables generated from the data by `documentation/generator/doc.py`. **Don't edit them; regenerate them.** |
| `game_binary/` | Exe patcher (`patcher/patcher.py`) and its patch files, game launchers (`launcher/`) |
| `editor/`, `maps/` | Map editor files and custom maps. Ignore them unless asked. |

Data folders: `core`, `hud`, `lua`, `creatures`, `heroes`, `spells`, `artifacts`, `skills`, `towns`, `maps`, `battlefields`, `www`, `www-creatures`, `www-heroes`, `www-artifacts` and `www-skills`.

## How the game reads the mod

- The game loads every `.pak` file (a ZIP archive) found in its `data` folder and **merges them into one virtual file system**. `game_data/<folder>/X/Y.xdb` is read as `/X/Y.xdb`, so the layout under each folder must match the paths the game expects. For example, `game_data/artifacts/GameMechanics/RefTables/Artifacts.xdb` is read as `/GameMechanics/RefTables/Artifacts.xdb`.
- A file at the same path as a vanilla file replaces it. Files can reference files in other paks.
- **The same path must never exist in two data folders.** `tools/release.py` packs all folders into a single pak.
- Data files are XML `.xdb` files that point to each other with `href="<path>#xpointer(/<RootType>)"`. A path is relative to the referencing file, or absolute from the virtual root. Textures are a `.dds` image plus a `(Texture).xdb` descriptor.
- Texts are `.txt` files in **UTF-16 LE**, referenced as `/Text/...` and similar paths. Some UI-local `.txt` files live next to the UI files in `game_data`; those are not translated.
- Custom mechanics are written in Lua 4.0, in `game_data/lua/scripts/`. The entry points are `advmap-startup.lua` and `combat-startup.lua`.

## Commands

The sync scripts package one folder and copy the pak into the game's `data` folder. They must be run **from `tools/`** and use `$env:H5_Folder` as the game folder when it is set:

```powershell
./sync-<folder>.ps1   # e.g. sync-heroes.ps1 (game_data/heroes), sync-www-heroes.ps1, sync-lua.ps1, sync-texts.ps1 (texts-EN)
```

Other tools:

```bash
python tools/generators/generate-heroes-ui.py   # encyclopedia generators (see ui.md), accept --dry-run / --debug
python tools/generators/generate-skills-ui.py
python tools/generators/check-ui-refs.py        # broken /UI/Doc references and unknown window names
python tools/generators/editor-heroes.py        # map editor hero palette (16 classes + heroes of Any.xdb), accepts --dry-run
python tools/generators/editor-artifacts.py     # map editor artifact palette (placeable artifacts of Artifacts.xdb), accepts --dry-run
python tools/generators/fix-arenas.py           # adapts combat arenas to the 14x11 grid, accepts --dry-run / --preview DIR
python tools/generators/generate-rmg-templates.py  # RMG templates from tools/generators/rmg-templates/*.yml (see rmg.md), accepts --dry-run / --preview FILE
python tools/generators/import-rmg-templates.py    # RMG template .xdb -> YAML source
python tools/debug/validate.py                  # XML syntax of every .xdb in game_data
python tools/translator.py                      # machine-translates texts-EN files newer than their translation
```

- `game_binary/launcher/build.ps1` builds the launchers `H5X.exe` and `H5X-Duel.exe` (MSVC, output in `game_binary/bin/`) and copies them to the game's root folder.
- `tools/update-doc.ps1` regenerates `documentation/*.md`.
- `tools/release.py` bumps `VERSION`, writes the in-game version text, and builds the release paks.
- Python dependencies: `jinja2` and `xmltodict` (generators), `pyyaml` (doc), `semver` (release), `deep_translator` (translator), `Pillow` (editor icons).

CI (`.github/workflows/`) only packages paks, on manual dispatch. It runs no tests.

## Conventions and gotchas

- **Line endings and encodings:** the repo stores files as-is (`core.autocrlf=false`). Generated `.xdb` files are UTF-8 with CRLF line endings, and game texts are UTF-16 LE. Never re-encode a file.
- **Game paths always use `/`.** Building one with `os.path.join` on Windows produces `\` (this caused a real bug). Use `game_path()` from `tools/generators/common.py`.
- **xmltodict pitfalls:** it returns a dict for a single `<Item>`, a list for several, and `None` for an empty node. Normalize with `as_list()` / `items()` from `common.py`.
- **Generated RMG templates:** `game_data/maps/RMG/Templates/*.xdb` and `game_texts/texts-EN/RMG/Templates/` come from `tools/generators/rmg-templates/*.yml`. Edit the YAML and rerun `generate-rmg-templates.py`.
- **Generated encyclopedia files** (most of `www-heroes` and `www-skills`) are rewritten on every generator run, and stale ones are deleted. Edit the generator or its templates, never the output. See ui.md for which files are hand-made.
- **Verifying a generator change:** on unchanged data, a generator run produces no git diff. Stage the current state, run the generator, then review `git diff --ignore-cr-at-eol`.
- **Duel files:** archives apply globally, even the content of a map that is not being played. The duel texts replace global texts (hero specs, skills, artifacts, lobby bonuses), so `sync-texts-duel.ps1` puts their pak in `<game>\duel\data\`, not in `data\`. The duel map is kept in `<game>\duel\Maps\H5X_Duel.h5m`, so it can only be played with the duel texts (move it to `Maps\` to edit it in the map editor). A translated duel pak (`h5x-texts-duel-DE.pak`) works the same way, but only one language should be in `duel\data\`. `H5X-Duel.exe` (game root) moves every file of `duel\` to the same path in the game folder, runs `bin\H5X.exe`, and moves the files back when the game exits. `duel\installed.txt` lists the moved files while the game runs, and the next launch of either launcher puts back the leftovers of a killed duel launcher. The regular launcher `H5X.exe` (game root) only does that cleanup, then starts `bin\H5X.exe` and exits. Both come from `game_binary/launcher/launcher.cpp` (`H5X_DUEL` define for the duel one). Their icons are embedded (a `.bat` file can't have its own icon): `H5X.ico` is a copy of `Other Resources/Heroes5.ico`, `H5X-Duel.ico` is the 64 px vanilla texture `UI/Common/Icons/Spell_Buff_Icons/Town Offence_Defence_spec _01` (the artwork of the duel lobby texture) upscaled 4x with Real-ESRGAN (`RealESRGAN_x4plus`), alpha upscaled bicubic to keep the soft shadow.
- **UI window names are global** across all paks. They are toggled by name through `UISSendUIMessage`, so keep them unique.
- In the Lua scripts, hero IDs are `H_*` constants defined in `game_data/lua/scripts/game/heroes.lua`. Starting armies are in `game_data/lua/scripts/advmap/handlers/starting-armies.lua`.
- When working on something the user plans to test in game, list which paks need syncing.
- **Combat arenas:** the H5X battlefield is 14x11 tiles instead of 12x10 (`game_binary/patches/h5toe/legacy/combat/h5m_battlefield-size.yml`; the engine stores width + 4 and height + 2 for the war machine columns and border rows, hence `GRID_X_MIN = 2` in `combat-data.lua`). An arena is an adventure map in `Maps/CombatArenas/` (terrain `.bin` with a float heightmap, static decoration objects). A scene (`AdventureFlybyScene`: `Scenes/CombatArenas/*.xdb`, `GameMechanics/CombatArenaTypes/*.xdb`, siege arenas in the town files) places the grid with its `MountPoint`. The grid grows from its center: the vanilla grid covers about x −1..11 and y −11.5..−1.5 around the mount point (measured, not traced in the exe), and the H5X grid covers x −2..12 and y −12..−1. `fix-arenas.py` shifts mount points and removes the decorations that now stand on the grid; it works from the vanilla files, so rerunning it changes nothing. Fixed obstacles (boat and abyss arenas) are in grid coordinates and were moved one column right.

## Status of the work in progress

- The **Creatures** tab compares two creatures side by side (`generate-creatures-ui.py`, see ui.md). It is generated and synced but not yet tested in game.
- The **Artifacts** tab (views by class, slot and set, hover descriptions, set bonuses) is generated but not yet tested in game.
- The hero spec panel has no title window, unlike the skills and spells panels.
- The **Skills** tab uses the build layout for every faction, Neutral included (`generate-skills-ui.py`, see ui.md): a grid of skill buttons, and the tree of the selected skill below it. It has been tested in game for Haven only. The level-up box has a single button opening the encyclopedia's Skills section, without the other sections: buttons with a `ButtonGroupID` inside a dialog made the next load crash (see ui.md). The old trees were removed.
- The **combat arenas** were adapted to the 14x11 grid (`fix-arenas.py`) but not yet tested in game. Unknown: whether the grid placement measured on the vanilla arenas is exact (a 1-tile error would leave objects on one edge), and how the boat and abyss fixed obstacles line up vertically (11 rows centered on 10 shift them by half a tile).
- **RMG team templates:** the generator writes `<Teams>` (team per start zone, by player count; see rmg.md), but the DLL patch that applies them (`RmgTeams.cpp` in H5X_DLL) is disabled: in game the 4-player Crossroads map still had no teams. Brief: `tools/generators/rmg-templates/dll-teams-brief.md`.
- The **Skills** tab grays out the branches a class can't learn. 12 basic masteries have no gray texture yet, so they use a `<Color>` tint (`generate-skills-ui.py --debug` lists them).
