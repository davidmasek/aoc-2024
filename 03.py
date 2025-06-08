import regex

with open("03.txt") as fh:
    content = fh.read()

# content = "xmul(2,4)&mul[3,7]!^don't()don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5)?mul(8,5))"
mul_regex = regex.compile(r"mul\((\d\d?\d?),(\d\d?\d?)\)")

tokens = []

# Valid tokens are:
# mul(dd?d?,dd?d?)
# do()
TOKEN_DO = 'do()'
# don't()
TOKEN_DONT = "don't()"
# Max length would be e.g.:
# mul(123,123)
MAX_TOKEN_LEN = 12
start = 0

for i in range(len(content)):
    c = content[i]
    if c == 'm':
        start = i
    elif c == 'd':
        start = i
    elif c == ')':
        buffer = content[start:i+1]
        start = i + 1
        if buffer == TOKEN_DO:
            tokens.append(TOKEN_DO)
        elif buffer == TOKEN_DONT:
            tokens.append(TOKEN_DONT)
        else:
            match = mul_regex.match(buffer)
            if match:
                a = int(match.group(1))
                b = int(match.group(2))
                tokens.append(("mul", a, b))

total = 0
for token in tokens:
    if len(token) == 3:
        total += token[1] * token[2]
print("A:", total)

total = 0
enabled = True
for token in tokens:
    if token == TOKEN_DO:
        enabled = True
    elif token == TOKEN_DONT:
        enabled = False
    elif len(token) == 3 and enabled:
        total += token[1] * token[2]
print("B:", total)

