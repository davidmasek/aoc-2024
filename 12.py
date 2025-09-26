from typing import Iterable
from dataclasses import dataclass
from pathlib import Path

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

    def neighbors(self) -> list["Position"]:
        return [self.up(), self.down(), self.left(), self.right()]


class Maze:
    def __init__(self, maze: dict[Position, str]):
        self.maze = maze

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

    return block_type, perimeter, area, current_blob


total = 0
for src, _ in maze.all():
    if src not in touched:
        t, p, a, blob = search(src)
        print(t, a, p)
        # print(blob)
        total += a * p


print("total:", total)
