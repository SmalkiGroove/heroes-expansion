# Heroes Expansion (H5X)

H5X is a mod for **Heroes of Might and Magic 5: Tribes of the East**. It changes heroes (two classes per faction), skills, creatures, artifacts and spells, adds custom mechanics in Lua, and includes an in-game encyclopedia. The current version is in `VERSION`. Player-facing notes are in `README.md`, `CHANGELOG.md` and `KNOWN_ISSUES.md`.

This file is the project's knowledge base. Each topic guide below has the details for one area. **Read the matching guide before working there, and update it, or this file, when you learn something non-obvious.**

| Topic | Guide | Covers |
|-------|-------|--------|
| In-game UI and encyclopedia | [.cursor/rules/ui.md](.cursor/rules/ui.md) | XDB UI anatomy, show/hide messages, buttons, encyclopedia structure, generators |
| Lua scripts | [.cursor/rules/lua.md](.cursor/rules/lua.md) | Lua 4.0 runtimes (adventure map and combat), entry points, engine functions |
| Texts | [.cursor/rules/text.md](.cursor/rules/text.md) | UTF-16 LE text files, formatting tags, translation |

`.github/copilot-instructions.md` and `.cursor/rules/` serve other assistants. Keep them consistent with this file.

## Repository layout

| Folder | Content |
|--------|---------|
| `game_data/<folder>/` | Game data, the source of truth. Each folder becomes one pak, `h5x-<folder>.pak`. |
| `game_texts/texts-<LANG>/` | Texts. `texts-EN` is the source; the PL, FR and RU folders are machine-translated and **must not be edited**. |
| `tools/` | Sync scripts, release, translator, generators, debug scripts |
| `documentation/` | Markdown tables generated from the data by `documentation/generator/doc.py`. **Don't edit them; regenerate them.** |
| `game_binary/` | Exe patcher (`patcher/patcher.py`) and its patch files |
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
python tools/debug/validate.py                  # XML syntax of every .xdb in game_data
python tools/translator.py                      # machine-translates texts-EN files newer than their translation
```

- `tools/update-doc.ps1` regenerates `documentation/*.md`.
- `tools/release.py` bumps `VERSION`, writes the in-game version text, and builds the release paks.
- Python dependencies: `jinja2` and `xmltodict` (generators), `pyyaml` (doc), `semver` (release), `deep_translator` (translator), `Pillow` (editor icons).

CI (`.github/workflows/`) only packages paks, on manual dispatch. It runs no tests.

## Conventions and gotchas

- **Line endings and encodings:** the repo stores files as-is (`core.autocrlf=false`). Generated `.xdb` files are UTF-8 with CRLF line endings, and game texts are UTF-16 LE. Never re-encode a file.
- **Game paths always use `/`.** Building one with `os.path.join` on Windows produces `\` (this caused a real bug). Use `game_path()` from `tools/generators/common.py`.
- **xmltodict pitfalls:** it returns a dict for a single `<Item>`, a list for several, and `None` for an empty node. Normalize with `as_list()` / `items()` from `common.py`.
- **Generated encyclopedia files** (most of `www-heroes` and `www-skills`) are rewritten on every generator run, and stale ones are deleted. Edit the generator or its templates, never the output. See ui.md for which files are hand-made.
- **Verifying a generator change:** on unchanged data, a generator run produces no git diff. Stage the current state, run the generator, then review `git diff --ignore-cr-at-eol`.
- **UI window names are global** across all paks. They are toggled by name through `UISSendUIMessage`, so keep them unique.
- In the Lua scripts, hero IDs are `H_*` constants defined in `game_data/lua/scripts/game/heroes.lua`. Starting armies are in `game_data/lua/scripts/advmap/handlers/starting-armies.lua`.
- When working on something the user plans to test in game, list which paks need syncing.

## Status of the work in progress

- The **Creatures** encyclopedia tab is hand-made, disabled in `www/UI/Doc/Root.(WindowSimpleShared).xdb`, and has broken references. `generate-creatures-ui.py` is empty.
- The **Artifacts** tab (views by class, slot and set, hover descriptions, set bonuses) is generated but not yet tested in game.
- The hero spec panel has no title window, unlike the skills and spells panels.
- The **Skills** tab of **Haven** uses a prototype build layout (`build_factions` in `generate-skills-ui.py`, see ui.md): a grid of skill buttons, and the tree of the selected skill below it. It hasn't been tested in game since its rework. The other factions keep the tree layout.
- The **Skills** tab grays out the branches a class can't learn. The skill masteries and 2 perks have no gray texture yet, so they use a `<Color>` tint that hasn't been tested in game (`generate-skills-ui.py --debug` lists them).
