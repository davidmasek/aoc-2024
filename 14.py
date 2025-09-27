import re
from pathlib import Path

inputs = """p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"""
inputs = Path("14.txt").read_text()

W = 101
H = 103
T = 100

q0 = q1 = q2 = q3 = 0

for line in inputs.splitlines():
    m = re.match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", line)
    assert m, line
    p_x, p_y, v_x, v_y = map(int, m.groups())
    p_x = (p_x + T * v_x) % W
    p_y = (p_y + T * v_y) % H
    is_left = p_x < W // 2
    is_right = p_x > W // 2
    is_top = p_y < H // 2
    is_bottom = p_y > H // 2
    if is_left and is_top:
        q0 += 1
    if is_right and is_top:
        q1 += 1
    if is_left and is_bottom:
        q2 += 1
    if is_right and is_bottom:
        q3 += 1

print("total:", q0 * q1 * q2 * q3)
