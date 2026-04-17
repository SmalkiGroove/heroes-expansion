# Heroes 5 Mod: Text Guide

## Structure

The mod's text files are located in the `game_texts` folder. There is one subfolder per language, for example `texts-EN` for english, `texts-PL` for polish, etc. Each subfolder contains text files with the same relative path and name, but different content depending on the language.

## Encoding

The text files are encoded in UTF-16 LE.

## Content

The content of the text files consists of regular text, mostly descriptions of game elements. Many text files also contain special tags that are used to format the text in the game. The tags mark the beginning of formatted sections but they do not close. We need to use a new tag to end the previous one.

The list of known tags is as follows:

- `<br>` - line break
- `<h1>`, `<h2>`, `<h3>` - headings
- `<body>` - remove formatting of the text that follows
- `<body_bright>` - remove formatting and make the text brighter
- `<color=COLOR>` - changes the color of the text that follows
- `<color_default>` - resets the color to default
- `<left>`, `<center>`, `<right>` - align the text to the left, center or right
- `<value=ARG>` - insert the value from lua script with the given argument

## Translation

The source of thruth for text files is the english version `texts-EN`.

When translating to other languages, the content of the text files should be the same as in the english version, except for the actual text. The tags should be kept in the same order and with the same arguments. The only difference is that the text between the tags can be translated.

When creating text files for another language, it is recommended to copy the english version and then translate the text, instead of creating a new file from scratch. This way we can be sure that the structure of the file is correct and that all tags are present.

If the folder where a text file should be written does not exist, it should be created. For example, if we want to create a text file for polish language in the `game_texts/texts-PL/Text/Game/Artifacts/AllSeeingCrown` folder, but the folder does not exist, we should create it first and then create the text file inside it.
