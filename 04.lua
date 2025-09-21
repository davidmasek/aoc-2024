local inspect = require 'lib.inspect'


local print = function(thing)
    print(inspect(thing))
end

local inputs = [[
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
]]

local filename = "04.txt"
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
for line in string.gmatch(inputs, "[^\r\n]+") do
    table.insert(lines, line)
end

local plane = {}
function plane.set(row, col, char)
    if char == "M" then
        plane[row .. "," .. col] = 1
        return
    elseif char == "S" then
        plane[row .. "," .. col] = -1
        return
    end
    error("invalid char '" .. char .. "'")
end

function plane.get(row, col)
    local val = plane[row .. "," .. col]
    return val
end

local a_locs = {}
for row, line in ipairs(lines) do
    for col = 1, #line do
        local char = line:sub(col, col)
        if char == "A" then
            table.insert(a_locs, { row = row, col = col })
        end
        if char == "M" or char == "S" then
            plane.set(row, col, line:sub(col, col))
        end
    end
end
lines = nil

local function any_null(...)
    local n_args = select('#', ...)
    for idx = 1, n_args do
        local v = select(idx, ...)
        if v == nil then
            return true
        end
    end
    return false
end

local function search(y, x)
    local tl, tr, bl, br
    tl = plane.get(y - 1, x - 1)
    bl = plane.get(y + 1, x - 1)
    tr = plane.get(y - 1, x + 1)
    br = plane.get(y + 1, x + 1)
    if any_null(tl, bl, tr, br) then
        return 0
    end
    if tl + br == 0 and tr + bl == 0 then
        return 1
    end
    return 0
end

local total = 0
for _, v in pairs(a_locs) do
    total = total + search(v.row, v.col)
end
print("total: " .. total)
