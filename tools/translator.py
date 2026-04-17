import sys
import os
import re
import datetime
from deep_translator import (GoogleTranslator)

workdir = os.path.dirname(os.path.abspath(__file__))

texts_root_path = "../game_texts"

translators = {
    'RU': GoogleTranslator(source='en',target='ru'),
    'PL': GoogleTranslator(source='en',target='pl'),
    'FR': GoogleTranslator(source='en',target='fr'),
}

def translate_text(text, translator):
    tag_pattern = r'<[^>]+>'
    segments = re.split(f'({tag_pattern})', text)
    translated_segments = []
    for segment in segments:
        if re.match(tag_pattern, segment):
            translated_segments.append(segment)
        elif not segment:
            translated_segments.append(segment)
        else:
            match = re.match(r'(\s*)(.*?)(\s*)$', segment, re.DOTALL)
            if match:
                leading_ws, content, trailing_ws = match.groups()
                if content.strip() == '':
                    translated_segments.append(segment)
                else:
                    try:
                        translated_text = translator.translate(text=content)
                        translated_segments.append(leading_ws + (translated_text if translated_text else content) + trailing_ws)
                    except Exception as err:
                        print(f"ERROR translating segment '{content}': {err}")
                        translated_segments.append(segment)
            else:
                translated_segments.append(segment)
    return ''.join(translated_segments)

sources = ["texts-EN", "texts-duel-EN"]

original = ""
translation = ""
for source in sources:
    for root, dirs, files in os.walk(os.path.join(workdir, texts_root_path, source)):
        for file in files:
            source_file_path = os.path.join(root, file)
            try:
                with open(source_file_path, 'r', encoding='utf-16-LE') as source_file:
                    original = source_file.read()
            except Exception as err:
                print(f"ERROR reading file: {err}")
                continue
            for lang, translator in translators.items():
                target_path = root.replace('EN', lang)
                target_file = os.path.join(target_path, file)
                if not os.path.exists(target_path):
                    os.makedirs(target_path)
                should_translate = False
                if not os.path.isfile(target_file):
                    should_translate = True
                else:
                    source_mtime = os.path.getmtime(source_file_path)
                    target_mtime = os.path.getmtime(target_file)
                    if source_mtime > target_mtime:
                        should_translate = True
                if should_translate:
                    print(target_file)
                    try:
                        translation = translate_text(original, translator)
                    except Exception as err:
                        print(f"ERROR: {err}")
                        continue
                    if translation != None:
                        with open(target_file, 'w', encoding='utf-16-LE') as translated_file:
                            translated_file.write(translation)

