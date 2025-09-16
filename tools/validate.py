import os
import xml.etree.ElementTree as xdb
from xml.etree.ElementTree import ParseError

workdir = os.path.dirname(os.path.abspath(__file__))
data_path = os.path.join(workdir, "../../game_data")

def validate_xml_syntax(file):
    try:
        x = xdb.parse(file)
        r = x.getroot()
        # print(f"XDB: {file}/{r} OK")
    except ParseError:
        print(f"XDB: {file}/! INVALID")

for path, subdirs, files in os.walk(data_path):
    subdirs[:] = [d for d in subdirs if d != "doc"]
    for file in files:
        if file.endswith('.xdb'):
            validate_xml_syntax(os.path.join(path, file))
