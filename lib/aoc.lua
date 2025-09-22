Map2D = require("lib.map")

local function read_file(filename)
    local inputs
    local file = io.open(filename, "r")
    if file then
        -- Read the entire file content into the 'inputs' string (*a is for 'all')
        inputs = file:read("*a")
        file:close() -- Close the file handle
    else
        -- Handle the case where the file couldn't be opened
        error("Could not open file: " .. filename)
    end
    return inputs
end

local function parse_lines(inputs)
    local lines = {}
    local w
    for line in string.gmatch(inputs, "[^\r\n]+") do
        w = #line
        table.insert(lines, line)
    end
    local h = #lines
    return {
        width = w,
        height = h,
        lines = lines,
    }
end

local function create_map(maze_raw)
    local map = Map2D:new()
    for row = 1, maze_raw.height do
        for col = 1, maze_raw.width do
            local val = maze_raw.lines[row]:sub(col, col)
            map:set(col, row, val)
        end
    end
    return map
end

local function parse_maze(inputs)
    local maze_raw = parse_lines(inputs)
    local maze = create_map(maze_raw)

    return maze
end


local aoc = {
    read_file = read_file,
    parse_maze = parse_maze,
}
return aoc
