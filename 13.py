import re
from pathlib import Path

# A_dx * a + B_dx * b = T_x
# A_dy * a + B_dy * b = T_y
# minimize 3a + b
inputs = """Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279"""
inputs = Path("13.txt").read_text()

total = 0
lines = inputs.splitlines()
for i in range(0, len(lines), 4):
    m = re.match(r".*X\+(\d+).*Y\+(\d+)", lines[i])
    assert m, lines[i]
    A_dx, A_dy = map(int, m.groups())

    m = re.match(r".*X\+(\d+).*Y\+(\d+)", lines[i + 1])
    assert m, lines[i + 1]
    B_dx, B_dy = map(int, m.groups())

    m = re.match(r".*X=(\d+).*Y=(\d+)", lines[i + 2])
    assert m, lines[i + 2]
    T_x, T_y = map(int, m.groups())
    T_x = T_x + 10000000000000
    T_y = T_y + 10000000000000

    print(A_dx, A_dy, B_dx, B_dy, T_x, T_y)
    D = A_dx * B_dy - A_dy * B_dx
    a_D = T_x * B_dy - T_y * B_dx
    b_D = A_dx * T_y - A_dy * T_x
    if D != 0:
        a = a_D / D
        b = b_D / D
        if a.is_integer() and b.is_integer():
            print("\tA:", a, "B:", b)
            total += 3 * a + b
        else:
            print("\tNo solution")
    else:
        # infinite solution for a_D = 0 and b_D = 0
        # else no solution
        raise ValueError("TODO")

print("total:", total)
