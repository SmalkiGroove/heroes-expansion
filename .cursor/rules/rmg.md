---
globs: game_data/maps/RMG/**, tools/generators/rmg-templates/**, tools/generators/*rmg*
alwaysApply: false
---
# Heroes 5 Mod: Random Map Generator Templates

The RMG templates in `game_data/maps/RMG/Templates/*.xdb` (`RMGTemplate`) are **generated**: edit their YAML source in `tools/generators/rmg-templates/`, never the `.xdb`. The game lists every template of `/RMG/Templates/` by itself, so a new source is all a new template needs. The rest of `game_data/maps/RMG/` (`Params/Default.xdb`, `CustomArmyTemplates/`, `TownRandomSpecGroup.xdb`) is copied from vanilla and edited by hand. How the exe uses the data: `G:\__H5__\H5X_DLL\.cursor\rules\h5x-re-rmg.mdc`.

## Tools

```bash
python tools/generators/generate-rmg-templates.py                    # every source -> .xdb + name texts, removes stale ones
python tools/generators/generate-rmg-templates.py --preview FILE.html # also draws the zone graphs (FILE outside the repo)
python tools/generators/generate-rmg-templates.py --dry-run --preview FILE.html SOURCE.yml  # draw one source, write nothing
python tools/generators/import-rmg-templates.py [FILE.xdb ...] [--force]  # .xdb -> YAML source (doesn't overwrite without --force)
```

- `rmg_common.py` holds the field table, the defaults and the YAML loader; the XDB layout is `templates-rmg/RMGTemplate.xdb.j2`.
- The 19 vanilla templates were imported, and regenerating them gives the vanilla files byte for byte. After a change to the tools, a run on unchanged sources must give no git diff.
- Sources starting with `_` are not templates: `_profiles.yml` holds profiles every source can use. `examples/` is not generated (the generator reads only `rmg-templates/*.yml`); `examples/Crossroads.yml` shows profiles and per-player zones.
- Sync: `sync-maps.ps1` (templates), `sync-texts.ps1` (names).

## Source format

```yaml
title: Crossroads            # name shown in the template list -> texts-EN/RMG/Templates/<name_file>
description: ...             # optional -> texts-EN/RMG/Templates/<description_file>
players: [2, 4]              # MinPlayers, MaxPlayers
map_size: [10, 36]           # MinMapSize, MaxMapSize, in area units (below)
underground: false           # informative only: the exe doesn't read it
grail: false                 # GraalOnMap
test: false                  # TestTemplate: hides the template
profiles:                    # zone presets; a profile can extend others with `profile: name` or `profile: [a, b]`
  home: {profile: start, mines: {wood: 1, ore: 1, gold: 1}}
per_player:                  # zones repeated for each player (`copies`, default players max)
  zones:
    - {id: home, profile: home}          # -> home1, home2, ...
  connections:
    - {from: home, to: next.home, guard: 20}   # next.<id>: that zone of the next player (ring)
zones:                       # zones after the per-player ones
  - {id: center, profile: rich, size: 25}
connections:
  - {from: home1, to: center, guard: 15}
```

- The file name is the template name (`<Name>`) and the `.xdb` name. `name_file` (default `<file name>.txt`) and `description_file` set the `href`s: imported vanilla templates keep the vanilla texts (`name_file` without `title`).
- A zone is the defaults, then its profiles in order, then its own fields. Unknown keys are errors (typos are caught). Zones without `id` are referred to by index.
- Zone index = position: per-player zones first (all copies of the first one, then of the second, ...), then `zones`. **Index order is player order**: each start zone takes the next player.
- Connections refer to zone ids or indexes. `two_way`, `guarded` and `wide` exist only to rebuild the vanilla files: the exe never reads them.
- Checks: warnings for fewer start zones than players, a start zone without town, an unknown `setting`, zones unreachable from zone 1, a `map_size` that lists on no map size.

## Zone fields

| YAML key | XDB tag | Default | Meaning (verified in the exe unless marked) |
|---|---|---|---|
| `setting` | `Setting` | `RACE_RANDOM_TYPE` | Zone faction: town, terrain, preset dwellings (`RMGPresetTable`). `RACE_SPECIAL` / `RACE_RANDOM_TYPE` / `RACE_NO_TYPE` are random; else `RACE_HEAVEN`, `PRESERVE`, `ACADEMY`, `DUNGEON`, `NECROMANCY`, `INFERNO`, `DWARF`, `STRONGHOLD`. A start zone with a random setting takes the player's faction |
| `water` | `CanBeWater` | false | |
| `size` | `Size` | 10 | Relative area: the zone gets about size / total of 90 % of the map (both levels) |
| `start` | `CanBePlayerStart` | false | Start zone of the next player |
| `town` | `Town` | false | Zone has a town |
| `town_guard` | `TownGuardStrenght` | 1 | Town guard power = 1000 × value |
| `mines` | `Mines` | none | Mine counts, `{wood, ore, mercury, crystal, sulfur, gem, gold}` or a list of 7. Wood and ore are placed near the town; guard by `Params/Default.xdb` level (gold has its own) |
| `abandoned_mines` | `AbandonedMines` | 0 | Number of abandoned mines |
| `dwellings` | `Dwellings` | `[]` | Item i = number of dwellings of creature tier i + 1, at most 7 items. Random towns option: random dwellings following the zone town; else the preset's tier 1–3 dwellings, and a military post for tiers 4–7 |
| `upgrades` | `UpgBuildingsDensity` | 0 | Upgrade buildings, × the experience level factor 0.2 / 0.5 / 1 / 2 / 4 |
| `treasures`, `chests` | `TreasureDensity`, `TreasureChestDensity` | 0 | Loose resources, gold, chests, campfires (no artifacts) |
| `treasure_blocks` | `TreasureBlocksTotalValue` | 0 | Value shared among guarded treasure blocks, the only RMG artifacts (guard = 2.5 × block value) |
| `prisons`, `cartographer` | `Prisons`, `LandCartographer` | 0 | Counts (inferred) |
| `shops`, `shrines`, `luck_morale`, `resource_buildings`, `treasure_buildings`, `buffs` | `ShopPoints`, `ShrinePoints`, `LuckMoralBuildingsDensity`, `ResourceBuildingsDensity`, `TreasureBuildingPoints`, `BuffPoints` | 0 | Each feeds one placement function; units not traced |
| `den_of_thieves`, `observatories` | `DenOfThieves`, `RedwoodObservatoryDensity` | 0 | Not traced |

The exe also has a zone field `Shipyard` (bool) that no vanilla template uses; the tools don't write it.

## Connections and map size

- Connection guard power = 2000 × `guard` (`BasicLeverGuardPower` × `ConnectionGuardLevel` of `Params/Default.xdb`), then × the monster level factor of the RMG screen (0.4 / 0.9 / 1.7 / 4 / 12). Below 100 no monster is placed, so a low `guard` means an unguarded passage.
- Zones that touch get a guarded passage on their border. Zones that don't touch get a two-way monolith (or a subterranean gate between levels), each end guarded by 0.71 × the power.
- `map_size` is in area units: map side 72 = 5, 96 = 10, 136 = 18, 176 = 31, 216 = 47, 256 = 66, 320 = 102. A template is listed for a side when its units are in range; with underground, 2 × units must be in range and `MaxMapSize` ≥ 10; with water, units count 0.7. The preview shows the sides that list each template.
