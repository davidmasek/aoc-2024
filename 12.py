from typing import Iterable, Optional
from dataclasses import dataclass
from pathlib import Path
from enum import IntEnum

inputs = """
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
"""
inputs = Path("12.txt").read_text()


class Direction(IntEnum):
    UP = 0
    RIGHT = 1
    DOWN = 2
    LEFT = 3

    def turn_right(self) -> "Direction":
        """Turn right (clockwise)."""
        return Direction((self + 1) % len(Direction))

    def turn_left(self) -> "Direction":
        """Turn left (anti-clockwise)."""
        return Direction((self + len(Direction) - 1) % len(Direction))


@dataclass(frozen=True)
class Position:
    row: int
    col: int

    def up(self) -> "Position":
        return Position(self.row - 1, self.col)

    def down(self) -> "Position":
        return Position(self.row + 1, self.col)

    def left(self) -> "Position":
        return Position(self.row, self.col - 1)

    def right(self) -> "Position":
        return Position(self.row, self.col + 1)

    def tl(self) -> "Position":
        return Position(self.row - 1, self.col - 1)

    def tr(self) -> "Position":
        return Position(self.row - 1, self.col + 1)

    def bl(self) -> "Position":
        return Position(self.row + 1, self.col - 1)

    def br(self) -> "Position":
        return Position(self.row + 1, self.col + 1)

    def neighbors(self) -> list["Position"]:
        return [self.up(), self.down(), self.left(), self.right()]

    def diagonal(self) -> list["Position"]:
        return [self.tl(), self.tr(), self.bl(), self.br()]

    def move(self, direction: Direction):
        if direction == Direction.UP:
            return self.up()
        if direction == Direction.LEFT:
            return self.left()
        if direction == Direction.RIGHT:
            return self.right()
        if direction == Direction.DOWN:
            return self.down()


RED = "\033[0;31m"
NC = "\033[0m"


class Maze:
    def __init__(self, maze: dict[Position, str]):
        self.maze = maze
        self.w = 0
        self.h = 0
        for pos in self.maze:
            self.w = max(self.w, pos.col)
            self.h = max(self.h, pos.row)

    def at(self, src: Position) -> str:
        return self.maze.get(src, "")

    def left(self, src: Position) -> str:
        return self.at(src.left())

    def right(self, src: Position) -> str:
        return self.at(src.right())

    def up(self, src: Position) -> str:
        return self.at(src.up())

    def down(self, src: Position) -> str:
        return self.at(src.down())

    def neighbors(self, src: Position) -> list[tuple[Position, str]]:
        return [(nb, self.at(nb)) for nb in src.neighbors()]

    def all(self) -> Iterable[tuple[Position, str]]:
        for k, v in self.maze.items():
            yield k, v

    def move(self, src: Position, direction: Direction) -> str:
        return self.at(src.move(direction))

    def count_corners(self, src: Position) -> int:
        val = self.at(src)
        ll = self.left(src)
        rr = self.right(src)
        dd = self.down(src)
        uu = self.up(src)
        tl = self.at(src.tl())
        tr = self.at(src.tr())
        bl = self.at(src.bl())
        br = self.at(src.br())

        corners = 0
        # exterior corners #
        #   X.X
        # .#---#.
        # X|A.A|X
        # .#---#.
        #   X.X
        if ll != val and uu != val:
            corners += 1
        if rr != val and uu != val:
            corners += 1
        if ll != val and dd != val:
            corners += 1
        if rr != val and dd != val:
            corners += 1
        # interior corners *
        #   X.X
        # .#---#.
        # X|A.A|X
        # .|.*-#X
        # X|A|X
        # .#-#.
        # X.X.X
        if ll == val and uu == val and tl != val:
            corners += 1
        if rr == val and uu == val and tr != val:
            corners += 1
        if ll == val and dd == val and bl != val:
            corners += 1
        if rr == val and dd == val and br != val:
            corners += 1

        return corners

    def print(self, src: Optional[Position], direction: Optional[Direction]):
        _h = self.h + 1
        _w = self.w + 1
        out = "#" + "-" * _w + "#\n"
        for r in range(_h):
            out += "|"
            for c in range(_w):
                if src and src.row == r and src.col == c:
                    char = "*"
                    if direction == Direction.LEFT:
                        char = "<"
                    elif direction == Direction.RIGHT:
                        char = ">"
                    elif direction == Direction.UP:
                        char = "^"
                    elif direction == Direction.DOWN:
                        char = "v"
                    char = f"{RED}{char}{NC}"
                else:
                    char = self.at(Position(r, c))
                if char:
                    out += char
                else:
                    out += "."
            out += "|\n"
        print(out, end="")
        print("#" + "-" * _w + "#")


def parse(inputs: str) -> Maze:
    maze = {}
    for r, row in enumerate(inputs.splitlines()):
        for c, char in enumerate(row):
            maze[Position(r, c)] = char
    return Maze(maze)


maze = parse(inputs)
all_blobs = []

touched = set()


def search(src: Position):
    current_blob = []
    block_type = maze.at(src)
    assert block_type
    q = [src]
    perimeter = 0
    area = 0
    touched.add(src)

    while q:
        src = q.pop()
        current_blob.append(src)
        area += 1

        for nb_pos, nb_val in maze.neighbors(src):
            if nb_val != block_type:
                perimeter += 1
                continue
            if nb_pos in touched:
                continue
            touched.add(nb_pos)
            q.append(nb_pos)

    corners = 0
    for src in current_blob:
        corners += maze.count_corners(src)

    sides = corners

    return block_type, perimeter, area, sides


total = 0
total_b = 0
for src, _ in maze.all():
    if src not in touched:
        t, p, a, corners = search(src)
        print(t, a, p, corners)
        total += a * p
        total_b += a * corners


print("total:", total)
print("total B:", total_b)
