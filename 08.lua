local inspect = require 'lib.inspect'

local boring_print = print

local print = function(thing)
    print(inspect(thing))
end

local inputs = [[............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
]]

local filename = "08.txt"
local file = io.open(filename, "r")
if file then
    -- Read the entire file content into the 'inputs' string (*a is for 'all')
    inputs = file:read("*a")
    file:close() -- Close the file handle
else
    -- Handle the case where the file couldn't be opened
    error("Could not open file: " .. filename)
end

local lines = {}
local W
for line in string.gmatch(inputs, "[^\r\n]+") do
    W = #line
    table.insert(lines, line)
end
local H = #lines

print { H = H, W = W }


local plane = {}

for row, line in ipairs(lines) do
    for col = 1, #line do
        local char = line:sub(col, col)
        if char ~= "." then
            if plane[char] == nil then
                plane[char] = {}
            end
            table.insert(plane[char], { row = row, col = col })
        end
    end
end
lines = nil

local function in_bounds(point)
    return point.row > 0 and point.col > 0
        and point.row <= H and point.col <= W
end

local total = 0
local antinodes = {}
function antinodes.add(row, col)
    if antinodes[row] == nil then
        antinodes[row] = {}
    end
    if antinodes[row][col] == nil then
        antinodes[row][col] = 1
        return 1
    else
        antinodes[row][col] = antinodes[row][col] + 1
        return 0
    end
end

function antinodes.get(row, col)
    return (antinodes[row] and antinodes[row][col]) or 0
end

for freq_type, locations in pairs(plane) do
    for _, point in pairs(locations) do
        for _, other in pairs(locations) do
            local dy = other.row - point.row
            local dx = other.col - point.col
            local ty = other.row + dy
            local tx = other.col + dx
            if point.row ~= other.row and point.col ~= other.col and in_bounds { row = ty, col = tx } then
                -- print { point = point, other = other, dy = dy, dx = dx, ty = ty, tx = tx }
                total = total + antinodes.add(ty, tx)
            end
        end
    end
end
print("total: " .. total)
