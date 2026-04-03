---
applyTo: "**"
---
# Project instructions

This repository contains files related to a mod for the game Heroes of Might and Magic 5: Tribes of the East.

## Folder structure

- `.git/`: Git repository files, ignore this folder.
- `.github/`: Contains the Github actions workflows and Copilot instructions.
- `documentation/`: Markdown documents based on the mod data files.
- `editor/`: Files relative to the game's editor app, ignore this folder.
- `game_binary/`: Custom exe patcher and associated patch files.
- `game_data/`: Game data files, which are the main focus of this repository. These files are used by the mod and are the source of truth for the mod's content. More details in the [data](#data) section below.
- `game_texts/`: Text files used by the game, mostly names and descriptions. More details in the [texts](#texts) section below.
- `maps/`: Custom maps for the game, ignore this folder.
- `tools/`: Scripts that are used to generate mod content, or to synchronize the game folder with the mod data files.

## Data

The game reads any .pak archive (ZIP format) placed in the `data` folder of the game installation directory. The "sync" Powershell scripts in the `tools` folder generate .pak files from the data files in this repository and placing them in the game's `data` folder.

Most of the data files are in XML format with a .xdb extension. They can refer to other mod files such as icons with .dds format, text files that are located under the `game_texts` folder, or other .xdb files.

Another important part of the mod are the lua scripts that are used to implement custom game mechanics. They are located in the `game_data/lua` folder.

In the `game_data` folder, the mod content is organized in subfolders based on the type of content, such as `artifacts`, `creatures`, `spells`, etc. Under these subfolders, the files and folders are organized as the game expects them to be, for example in `game_data/artifacts` we find `GameMechanics/RefTables/Artifacts.xdb` for artifact data files, which is the actual path from the .pak archive's root that the game reads.

## Texts

Similarly to the data files, the text files are archived into a .pak file and placed in the game's `data` folder. The text files are in .txt format with encoding UTF-16 LE.

Under the `game_texts` folder, there are subfolders for each language supported by the mod, such as `texts-EN` for english, `texts-PL` for polish, etc. The source of truth for the text content is the english text files, which are edited directly in this repository. The other language text files are generated from the english ones using a translation tool, and should not be edited directly.
