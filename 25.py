inputs_file = "25.full.txt"


blocks = []

with open(inputs_file) as fh:
    block = []
    for line in fh:
        line = line.strip()
        if line:
            block.append(line)
        else:
            assert block
            blocks.append(block)
            block = []
    if block:
        blocks.append(block)

print("# blocks:", len(blocks))

locks = []
keys = []

for block in blocks:
    sizes = []
    for col in range(len(block[0])):
        c = -1  # just to count it the way the examples do
        for row in range(len(block)):
            c += 1 if block[row][col] == "#" else 0
        sizes.append(c)

    # lock
    if block[0][0] == "#":
        locks.append(sizes)
    # key
    else:
        assert block[0][0] == "."
        keys.append(sizes)

space = len(blocks[0]) - 2
print("space:", space)

print("locks:", locks)
print("keys:", keys)


def match(lock, key):
    for i in range(len(lock)):
        if lock[i] + key[i] > space:
            return False
    return True


matches = 0
for lock in locks:
    for key in keys:
        if match(lock, key):
            matches += 1

print("matches:", matches)
