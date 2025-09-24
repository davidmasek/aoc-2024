inputs = "125 17".split()
inputs = "20 82084 1650 3 346355 363 7975858 0".split()


def blink(inputs: list[str]) -> list[str]:
    blinked = []
    for p in inputs:
        if len(p) % 2 == 0:
            blinked.append(str(int(p[: len(p) // 2])))
            blinked.append(str(int(p[len(p) // 2 :])))
            continue
        if p == "0":
            blinked.append("1")
            continue
        blinked.append(str(int(p) * 2024))
    return blinked


_cache = {}


def blink_n(part: str, n: int) -> int:
    if (part, n) in _cache:
        return _cache[(part, n)]
    parts = [part]
    total = 0
    parts = blink(parts)
    if n == 1:
        _cache[(part, n)] = len(parts)
        return _cache[(part, n)]
    for p in parts:
        total += blink_n(p, n - 1)

    _cache[(part, n)] = total
    return _cache[(part, n)]


print("initial:")
print(" ", inputs)

MODE = "B"
steps = 75
total = -1

if MODE == "A":
    for n in range(steps):
        inputs = blink(inputs)  # type: ignore
    total = len(inputs)

if MODE == "B":
    total = 0
    for part in inputs:
        stones = blink_n(part, steps)
        total += stones

print(f"After {steps} blinks:\n {total} stones")
