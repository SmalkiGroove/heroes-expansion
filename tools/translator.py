import sys
import os
from deep_translator import (GoogleTranslator)

workdir = os.path.dirname(os.path.abspath(__file__))

texts_root_path = "../game_texts"

translators = {
    'RU': GoogleTranslator(source='en',target='ru'),
}

original = ""
translation = ""
for root, dirs, files in os.walk(os.path.join(workdir, texts_root_path, "texts-EN")):
    for file in files:
        with open(os.path.join(root, file), 'r', encoding='utf-16-LE') as source_file:
            original = source_file.read()
        for lang,translator in translators.items():
            target_path = root.replace('EN',lang)
            target_file = os.path.join(target_path, file)
            if not os.path.exists(target_path):
                os.makedirs(target_path)
            if not os.path.isfile(target_file):
                translation = translator.translate(text=original)
                with open(target_file, 'w', encoding='utf-16-LE') as translated_file:
                    translated_file.write(translation)
                # print(f"{original} => {translation}")

    