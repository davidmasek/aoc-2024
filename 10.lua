local inspect = require "lib.inspect"
local aoc = require "lib.aoc"
local Map2D = require "lib.map"
local List = require "lib.list"

local print = function(thing)
    print(inspect(thing))
end

local inputs = [[
..90..9
...1.98
...2..7
6543456
765.987
876....
987....
]]

inputs = aoc.read_file("10.txt")

local maze = aoc.parse_maze(inputs)
    :apply(tonumber)

local function solve(start)
    local visited = Map2D:new()
    local queue = List:new()
    queue:pushright(start)

    local score = 0

    while not queue:empty() do
        local current = queue:popleft()
        if current.val == 9 and visited:get(current.x, current.y) == nil then
            score = score + 1
        end
        local nbs = maze:adjacent(current)
        for _, nb in pairs(nbs) do
            if nb.val == current.val + 1 then
                queue:pushright(nb)
            end
        end
        -- for version A uncomment the following line:
        -- visited:set(current.x, current.y, true)
    end
    return score
end

local sum = 0
for pos in maze:all(function(val) return val == 0 end) do
    local score = solve(pos)
    sum = sum + score
end
print("score: " .. sum)
