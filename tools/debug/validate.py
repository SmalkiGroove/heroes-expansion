"""Checks the data folders of game_data:
- the XML syntax of every .xdb file;
- that no file path exists in two data folders: the game merges all the paks into one virtual
  file system, and release.py packs every folder into a single pak. Paths are compared ignoring
  case, as Windows does.
Exits with 1 when a check fails.
"""

import argparse
import os
import subprocess
import sys
import xml.etree.ElementTree as xdb
from multiprocessing import Pool
from xml.etree.ElementTree import ParseError

workdir = os.path.dirname(os.path.abspath(__file__))
repo_root = os.path.abspath(os.path.join(workdir, "../.."))
data_path = os.path.join(repo_root, "game_data")

def rel_path(path):
    return os.path.relpath(path, repo_root).replace('\\', '/')

def validate_xml_syntax(file):
    """None when the file is valid, else the error (its message includes the line and column)."""
    try:
        xdb.parse(file)
        return None
    except ParseError as error:
        return str(error)

def scan_data_folders():
    """Every .xdb file of the data folders, and the paths found in several folders."""
    xdb_files = []
    owners = {}
    for folder in sorted(os.listdir(data_path)):
        root = os.path.join(data_path, folder)
        if not os.path.isdir(root):
            continue
        for path, subdirs, files in os.walk(root):
            for file in files:
                full_path = os.path.join(path, file)
                if file.endswith('.xdb'):
                    xdb_files.append(full_path)
                virtual_path = os.path.relpath(full_path, root).replace('\\', '/')
                owners.setdefault(virtual_path.lower(), []).append(f"{folder}/{virtual_path}")
    duplicates = sorted(paths for paths in owners.values() if len(paths) > 1)
    return xdb_files, duplicates

def git(*args):
    return subprocess.run(["git", "-C", repo_root, *args], capture_output=True, text=True)

def changed_xdb_files(ref):
    """The .xdb files of game_data changed since ref: committed since, uncommitted (staged or not) or untracked."""
    def git_paths(*args):
        result = git(*args, "-z", "--", "game_data")
        result.check_returncode()
        return [path for path in result.stdout.split('\0') if path]
    paths = set(git_paths("diff", "--name-only", ref) + git_paths("ls-files", "--others", "--exclude-standard"))
    files = [os.path.join(repo_root, path) for path in sorted(paths) if path.endswith('.xdb')]
    return [file for file in files if os.path.isfile(file)]

def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--ref", help="only check the syntax of the .xdb files changed since this git ref (tag, commit, HEAD...), uncommitted and untracked files included; duplicates are always checked")
    parser.add_argument("-j", "--jobs", type=int, default=os.cpu_count(), help="number of parallel processes (default: one per CPU)")
    args = parser.parse_args()
    if args.ref and git("rev-parse", "--verify", "--quiet", f"{args.ref}^{{commit}}").returncode != 0:
        parser.error(f"unknown git ref '{args.ref}'")

    xdb_files, duplicates = scan_data_folders()
    if args.ref:
        xdb_files = changed_xdb_files(args.ref)

    for paths in duplicates:
        print(f"DUPLICATE: {' | '.join(paths)}")

    with Pool(max(1, args.jobs)) as pool:
        errors = pool.map(validate_xml_syntax, xdb_files, chunksize=64)
    invalid = [(file, error) for file, error in zip(xdb_files, errors) if error]
    for file, error in invalid:
        print(f"INVALID: {rel_path(file)}: {error}")

    print(f"{len(xdb_files)} .xdb files checked, {len(invalid)} invalid, {len(duplicates)} duplicate paths")
    sys.exit(1 if invalid or duplicates else 0)

if __name__ == "__main__":
    main()
