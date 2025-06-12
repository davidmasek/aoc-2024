from pathlib import Path
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--full", action="store_true")
args = parser.parse_args()

if args.full:
    map_raw = Path("06.txt").read_text()
else:
    map_raw = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

guard_dir = "up"

# Parse into {(x, y): char} and find guard position
map_lines = [line for line in map_raw.strip().split("\n")]

game_map = {}
guard_pos = None

for y, line in enumerate(map_lines):
    for x, char in enumerate(line):
        game_map[(x, y)] = char
        if char == "^":
            guard_pos = (x, y)

rotate_map = {
    "up": "right",
    "right": "down",
    "down": "left",
    "left": "up",
}


# Direction rotation
def rotate(dir):
    return rotate_map[dir]


# Step one move
def step(state):
    game_map, (guard_x, guard_y), guard_dir = state

    if guard_dir == "up":
        next_pos_target = (guard_x, guard_y - 1)
    elif guard_dir == "down":
        next_pos_target = (guard_x, guard_y + 1)
    elif guard_dir == "left":
        next_pos_target = (guard_x - 1, guard_y)
    elif guard_dir == "right":
        next_pos_target = (guard_x + 1, guard_y)
    else:
        raise ValueError(f"invalid direction {guard_dir}")

    next_tile = game_map.get(next_pos_target, None)

    if next_tile is None:
        next_pos_actual, next_dir = None, guard_dir
    elif next_tile == "#":
        next_pos_actual, next_dir = (guard_x, guard_y), rotate(guard_dir)
    elif next_tile == ".":
        next_pos_actual, next_dir = next_pos_target, guard_dir
    else:
        raise ValueError(f"invalid next_tile {next_tile}")

    # Mutate a copy of the map
    # new_map = dict(game_map)
    game_map[(guard_x, guard_y)] = "."
    game_map[next_pos_actual] = "^"

    return game_map, next_pos_actual, next_dir


# Recursive walking
def step_all(state: tuple, occupied: set, prev_states: set):
    while True:
        _, pos, dir = state

        if pos is None:
            return occupied, "escaped"

        occupied.add(pos)
        if (pos, dir) in prev_states:
            return occupied, "looped"

        prev_states.add((pos, dir))
        state = step(state)


# Part A
occupied, _ = step_all((game_map, guard_pos, guard_dir), set(), set())
print("A:", len(occupied))

# Part B
count = 0
for spot in occupied:
    new_map = dict(game_map)
    new_map[spot] = "#"
    _, result = step_all((new_map, guard_pos, guard_dir), set(), set())
    if result != "escaped":
        count += 1
print("B:", count)
