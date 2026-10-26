"""Adapts the combat arenas to the H5X battlefield (14x11 tiles instead of 12x10).

An arena is an adventure map (Maps/CombatArenas/<Name>/) decorated with static objects. A scene
(AdventureFlybyScene) places the combat grid on it with its MountPoint. Measured on the vanilla arenas
(the engine code was not traced), the 12x10 grid covers world x -1..11 and y -11.5..-1.5 relative to
the mount point, and the designers kept the tiles x -2..11, y -12..-2 free of objects. The engine grows
the grid from its center (seen in game), so the 14x11 H5X grid covers x -2..12 and y -12..-1, and the
war machines stand one column further out. Decorations placed just outside the vanilla grid now stand
on the grid or on the war machines.

For each scene, the script tries mount point shifts of up to 2 tiles and keeps the cheapest one. The
cost counts the objects to remove from the new grid and the objects left in the war machine columns
(weighted by their size), the uneven terrain under the new grid, and the shift itself. It then removes
the objects that overlap the new grid. Kept: objects that overlapped a vanilla grid, which are part of
the battlefield (a crater, a bridge), and objects bigger than MAX_REMOVED tiles (they are listed). Scenes of siege arenas and of arenas with fixed obstacles are
not shifted: their walls and blocked tiles are placed in grid coordinates. The fixed obstacles are
moved one column right so that they stay centered (grid x 2..13 became 2..15).

Skipped: scenes whose vanilla grid is already obstructed (objects or uneven ground on more than 30% of
it, which are leftovers the game doesn't use), and the GameMechanics/CombatArenaTypes files that
CombatArenaTypes.xdb doesn't reference.

Everything is computed from the vanilla files, so a second run changes nothing. Writes:
  game_data/battlefields/Maps/CombatArenas/...     arenas without the removed objects
  game_data/battlefields/<scene path>              vanilla scenes with a shifted mount point
  game_data/<folder>/<scene path>                  mod scenes (towns) with a shifted mount point
  game_data/battlefields/ArenaObjects/...          fixed obstacles

--preview DIR draws one PNG per scene: terrain height in gray, kept objects in dark gray, objects of a
vanilla grid in blue, removed objects in red, the vanilla grid in yellow, the new grid in green and the
war machine columns in light green.
"""

import argparse
import math
import os
import re
import statistics
import struct

from editor_links import GAME_DATA, Sources

BATTLEFIELDS = os.path.join(GAME_DATA, "battlefields")
ARENAS = "Maps/CombatArenas/"
# Vanilla files that place a combat grid on an arena (the mod's own files are searched too)
SCENE_PREFIXES = ("scenes/combatarenas/", "gamemechanics/combatarenatypes/", "mapobjects/")
ARENA_TYPES = "/GameMechanics/CombatArenaTypes/CombatArenaTypes.xdb"
FIXED_OBSTACLES = ("ArenaObjects/BoatArena/BoatArenaBlocked.xdb", "ArenaObjects/AbyssArena/AbyssArenaBlocked.xdb")

# Tile rectangles (x0, x1, y0, y1), inclusive, relative to the vanilla mount point. A tile (x, y) is
# the square from (x, y) to (x + 1, y + 1).
VANILLA_GRID = (-1, 10, -11, -3)  # tiles fully covered by the vanilla grid
NEW_GRID = (-2, 11, -12, -2)      # tiles covered by the H5X grid
MARGIN = (-3, 12, -12, -2)        # the H5X grid and its war machine columns
SHIFTS = [(dx, dy) for dx in range(-2, 3) for dy in range(-2, 3)]
FLAT = 0.3           # height difference from the grid's ground that counts as uneven
OBSTRUCTED = 0.3     # part of a vanilla grid with objects or uneven ground above which a scene is skipped
TERRAIN_WEIGHT = 3   # per uneven tile under the new grid
MARGIN_WEIGHT = 0.5  # per object tile left in the war machine columns
SHIFT_WEIGHT = 1     # per tile of mount point shift
MAX_REMOVED = 12     # tiles of the biggest object that can be removed (a mountain would leave a hole)

SCENE = re.compile(r'<Scenery href="([^"#]*)#[^"]*"/>.*?<MountPoint>\s*<Pos>\s*<x>(-?\d+)</x>\s*<y>(-?\d+)</y>', re.S)
OBJECT = re.compile(r'^\t\t<Item href="#n:inline\(\w+\)" id="([^"]+)">\r?\n(.*?)^\t\t</Item>\r?\n', re.S | re.M)
POS = re.compile(r'<Pos>\s*<x>([-\d.e]+)</x>\s*<y>([-\d.e]+)</y>.*?<Rot>([-\d.e]+)</Rot>.*?<Shared href="([^"#]*)', re.S)
POINT = re.compile(r'<x>(-?\d+)</x>\s*<y>(-?\d+)</y>')


def vanilla(src, path):
    e = src.paks.get(path.lstrip("/").lower())
    return e[0].read(e[1]).decode("utf-8") if e else None


def mod_file(path):
    """game_data file of a game path, whatever its data folder, else None."""
    for d in os.listdir(GAME_DATA):
        f = os.path.join(GAME_DATA, d, *path.lstrip("/").split("/"))
        if os.path.exists(f):
            return f
    return None


def read(path):
    with open(path, encoding="utf-8", newline="") as f:
        return f.read()


def resolve(base, href):
    if href.startswith("/"):
        return href
    return "/".join(base.split("/")[:-1] + [href])


def find_scenes(src):
    """{game path: (vanilla text or None, mod file or None)} of the files that mount a grid on an arena."""
    def candidate(path):
        path = path.lower()
        return path.endswith(".xdb") and any(path.startswith(p) and "/" not in path[len(p):] for p in SCENE_PREFIXES)

    paths = {n for k, (z, n) in src.paks.items() if candidate(k)}
    for d in os.listdir(GAME_DATA):
        root = os.path.join(GAME_DATA, d)
        for folder, _, files in os.walk(root):
            for f in files:
                path = os.path.relpath(os.path.join(folder, f), root).replace(os.sep, "/")
                if candidate(path):
                    paths.add(path)
    types = vanilla(src, ARENA_TYPES)
    used = {resolve(ARENA_TYPES, h).lower() for h in re.findall(r'<Item href="([^"#]+)#', types)} | {ARENA_TYPES.lower()}
    scenes = {}
    for path in sorted(paths):
        if path.lower().startswith(SCENE_PREFIXES[1]) and "/" + path.lower() not in used:
            continue
        mod = mod_file(path)
        text = read(mod) if mod else vanilla(src, path)
        if text and ARENAS in text and SCENE.search(text):
            scenes["/" + path] = (vanilla(src, path), mod)
    return scenes


def footprints(src, shared, href):
    if href not in shared:
        text = src.read(href)
        text = text.decode("utf-8", "replace") if text else ""
        block = re.search(r"<blockedTiles>(.*?)</blockedTiles>", text, re.S)
        shared[href] = [tuple(map(int, p)) for p in POINT.findall(block.group(1))] if block else []
    return shared[href]


def rotate(p, rot):
    x, y = p
    for _ in range(round(rot / (math.pi / 2)) % 4):
        x, y = -y, x
    return x, y


def objects(src, shared, text):
    """[(id, set of tiles)] of an arena's objects."""
    out = []
    for m in OBJECT.finditer(text):
        pos = POS.search(m.group(2))
        if not pos:
            continue
        x, y, rot = math.floor(float(pos.group(1))), math.floor(float(pos.group(2))), float(pos.group(3))
        tiles = {(x + dx, y + dy) for dx, dy in (rotate(p, rot) for p in footprints(src, shared, pos.group(4)))}
        out.append((m.group(1), tiles or {(x, y)}))
    return out


def chunks(b, start, end):
    out = {}
    while start < end:
        cid = b[start]
        if b[start + 1] & 1:
            size, start = struct.unpack_from("<I", b, start + 1)[0] >> 1, start + 5
        else:
            size, start = b[start + 1] >> 1, start + 2
        out[cid] = (start, start + size)
        start += size
    return out


def heights(data):
    """(width, [vertex heights]) of a terrain .bin: chunk 1/1/5 holds the width, height and floats."""
    c = chunks(data, 0, len(data))
    for cid in (1, 1, 5):
        c = chunks(data, *c[cid])
    width = struct.unpack_from("<I", data, c[1][0])[0]
    start, end = c[3]
    return width, struct.unpack_from("<%df" % ((end - start) // 4), data, start)


def zone(rect, mx, my):
    x0, x1, y0, y1 = rect
    return {(mx + x, my + y) for x in range(x0, x1 + 1) for y in range(y0, y1 + 1)}


class Arena:
    def __init__(self, src, shared, path):
        self.path = path
        self.name = path.split("/")[3]
        self.vanilla = vanilla(src, path)
        self.file = os.path.join(BATTLEFIELDS, *path.lstrip("/").split("/"))
        self.objects = objects(src, shared, self.vanilla)
        floor = int(re.search(r"<InitialFloor>(\d+)", self.vanilla).group(1))
        tag = "UndergroundTerrainFileName" if floor else "GroundTerrainFileName"
        terrain = re.search(rf'<{tag} href="([^"]*)"', self.vanilla).group(1)
        self.width, self.heights = heights(src.read(resolve(path, terrain)))
        self.intended = set()  # objects of a vanilla grid

    def height(self, x, y):
        i = y * self.width + x
        return self.heights[i] if 0 <= x < self.width and 0 <= i < len(self.heights) else None

    def ground(self, mx, my):
        return statistics.median(h for x, y in zone(VANILLA_GRID, mx, my) if (h := self.height(x, y)) is not None)

    def uneven(self, tiles, ground):
        return {(x, y) for x, y in tiles
                if any(h is None or abs(h - ground) > FLAT for h in (self.height(x + i, y + j) for i in (0, 1) for j in (0, 1)))}

    def overlapping(self, tiles):
        return [(i, t) for i, t in self.objects if t & tiles]

    def obstruction(self, mx, my):
        grid = zone(VANILLA_GRID, mx, my)
        covered = set().union(*(t for _, t in self.overlapping(grid))) & grid
        return len(covered | self.uneven(grid, self.ground(mx, my))) / len(grid)

    def plan(self, mx, my, can_shift):
        """(cost, shift, removed objects, objects left on the new grid, uneven tiles) of the cheapest shift."""
        ground, own = self.ground(mx, my), {i for i, _ in self.overlapping(zone(VANILLA_GRID, mx, my))}
        best = None
        for sx, sy in SHIFTS if can_shift else [(0, 0)]:
            grid, margin = zone(NEW_GRID, mx + sx, my + sy), zone(MARGIN, mx + sx, my + sy)
            over = self.overlapping(grid)
            removed = [(i, t) for i, t in over if i not in self.intended and len(t) <= MAX_REMOVED]
            # big objects, and objects of another scene's vanilla grid, stay on this grid
            left = [(i, t) for i, t in over if i not in own and (i, t) not in removed]
            edge = [t & (margin - grid) for i, t in self.overlapping(margin - grid)]
            uneven = self.uneven(grid, ground)
            cost = (sum(len(t) for _, t in removed) + sum(len(t & grid) for _, t in left)
                    + MARGIN_WEIGHT * sum(map(len, edge)) + TERRAIN_WEIGHT * len(uneven)
                    + SHIFT_WEIGHT * (abs(sx) + abs(sy)))
            if best is None or cost < best[0]:
                best = (cost, (sx, sy), removed, left, uneven)
        return best

    def without(self, ids):
        """Current mod arena text without the objects of ids."""
        return OBJECT.sub(lambda m: "" if m.group(1) in ids else m.group(0), read(self.file))


def shift_mounts(text, mounts):
    """Text with the mount point of its n-th scene set to mounts[n] (None keeps it)."""
    out, last = [], 0
    for m, pos in zip(SCENE.finditer(text), mounts):
        if pos:
            out += [text[last:m.start(2)], str(pos[0]), text[m.end(2):m.start(3)], str(pos[1])]
            last = m.end(3)
    return "".join(out) + text[last:]


def preview(arena, mx, my, shift, removed, path):
    from PIL import Image, ImageDraw
    scale, border = 12, 12
    x0, y0 = mx + MARGIN[0] - border, my + MARGIN[2] - border
    size = (MARGIN[1] - MARGIN[0] + 1 + 2 * border, MARGIN[3] - MARGIN[2] + 1 + 2 * border)
    image = Image.new("RGB", (size[0] * scale, size[1] * scale))
    draw = ImageDraw.Draw(image)
    ground = arena.ground(mx, my)

    def box(x, y):  # world y grows upward, image y downward
        px, py = (x - x0) * scale, (size[1] - 1 - (y - y0)) * scale
        return [px, py, px + scale - 1, py + scale - 1]

    for x in range(x0, x0 + size[0]):
        for y in range(y0, y0 + size[1]):
            h = arena.height(x, y)
            v = 0 if h is None else max(0, min(255, int(160 + (h - ground) * 40)))
            draw.rectangle(box(x, y), fill=(v, v, v))
    removed = {i for i, _ in removed}
    for i, tiles in arena.objects:
        color = (220, 40, 40) if i in removed else (60, 110, 230) if i in arena.intended else (70, 70, 70)
        for x, y in tiles:
            draw.rectangle(box(x, y), fill=color)
    sx, sy = mx + shift[0], my + shift[1]
    for rect, (zx, zy), color in ((MARGIN, (sx, sy), (150, 240, 150)), (VANILLA_GRID, (mx, my), (240, 200, 0)),
                                  (NEW_GRID, (sx, sy), (0, 200, 0))):
        a, b = box(zx + rect[0], zy + rect[3]), box(zx + rect[1], zy + rect[2])
        draw.rectangle([a[0], a[1], b[2], b[3]], outline=color, width=2)
    image.save(path)


def write(path, text, dry_run):
    print(("would write " if dry_run else "write ") + os.path.relpath(path, GAME_DATA))
    if not dry_run:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8", newline="") as f:
            f.write(text)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true", help="print what would be written, write nothing")
    parser.add_argument("--preview", metavar="DIR", help="draw one PNG per scene in DIR")
    args = parser.parse_args()

    src, shared, arenas = Sources(), {}, {}
    scenes = find_scenes(src)

    # Vanilla mount point of every scene: (scene path, index in its file, arena, mx, my, can shift)
    entries = []
    for path, (text, mod) in scenes.items():
        base = text or read(mod)
        siege = '<ArenaDesc href="/' in base
        matches = list(SCENE.finditer(base))
        for n, m in enumerate(matches):
            block = base[m.start():matches[n + 1].start() if n + 1 < len(matches) else len(base)]
            arena_path = resolve(path, m.group(1))
            if not vanilla(src, arena_path):
                print(f"skip {path} #{n}: {arena_path} is not a vanilla arena")
                continue
            if arena_path.lower() not in arenas:
                arenas[arena_path.lower()] = Arena(src, shared, arena_path)
            arena, mx, my = arenas[arena_path.lower()], int(m.group(2)), int(m.group(3))
            obstruction = arena.obstruction(mx, my)
            if obstruction > OBSTRUCTED:
                print(f"skip {path} #{n}: {arena.name} mount ({mx}, {my}), vanilla grid {obstruction:.0%} obstructed")
                continue
            fixed = "BoatArenaObstacles" in block or "AbyssArenaObstacles" in block
            entries.append((path, n, arena, mx, my, not siege and not fixed))
    for path, n, arena, mx, my, _ in entries:
        arena.intended.update(i for i, _ in arena.overlapping(zone(VANILLA_GRID, mx, my)))

    mounts, removals = {}, {}
    for path, n, arena, mx, my, can_shift in entries:
        cost, shift, removed, left, uneven = arena.plan(mx, my, can_shift)
        mounts.setdefault(path, {})[n] = (mx + shift[0], my + shift[1]) if shift != (0, 0) else None
        removals.setdefault(arena.path, set()).update(i for i, _ in removed)
        print(f"{path} #{n}: {arena.name} mount ({mx}, {my}) shift {shift}, {len(removed)} objects removed, "
              f"{len(left)} left on the grid, {len(uneven)} uneven tiles")
        if args.preview:
            os.makedirs(args.preview, exist_ok=True)
            preview(arena, mx, my, shift, removed, os.path.join(args.preview, f"{arena.name}_{mx}_{my}.png"))

    for arena in arenas.values():
        text = arena.without(removals.get(arena.path, set()))
        if text != read(arena.file):
            write(arena.file, text, args.dry_run)

    for path, by_index in sorted(mounts.items()):
        if not any(by_index.values()):
            continue
        text, mod = scenes[path]
        target = mod or os.path.join(BATTLEFIELDS, *path.lstrip("/").split("/"))
        current = read(target) if os.path.exists(target) else text
        # mount points are absolute (vanilla + shift): applying them again changes nothing
        out = shift_mounts(current, [by_index.get(n) for n in range(len(SCENE.findall(current)))])
        if out != current or not os.path.exists(target):
            write(target, out, args.dry_run)

    for path in FIXED_OBSTACLES:
        out = re.sub(r"<x>(-?\d+)</x>", lambda m: f"<x>{int(m.group(1)) + 1}</x>", vanilla(src, path))
        target = os.path.join(BATTLEFIELDS, *path.split("/"))
        if not os.path.exists(target) or read(target) != out:
            write(target, out, args.dry_run)


if __name__ == "__main__":
    main()
