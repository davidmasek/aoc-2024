local Map2D = {}

function Map2D:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o._map = {}
    return o
end

function Map2D:set(x, y, val)
    if self._map[y] == nil then
        self._map[y] = {}
    end
    self._map[y][x] = val
end

function Map2D:get(x, y)
    if self._map[y] == nil then
        return nil
    end
    return self._map[y][x]
end

function Map2D:all(cond)
    local map_instance = self
    cond = cond or function(_) return true end

    local y_key, row = next(map_instance._map, nil)
    local x_key = nil

    return function()
        while y_key do
            repeat
                assert(row)
                local val
                x_key, val = next(row, x_key)
                if x_key and cond(val) then
                    return { x = x_key, y = y_key, val = val }
                end
            until x_key == nil
            y_key, row = next(map_instance._map, y_key)
        end
        return nil
    end
end

function Map2D:apply(func)
    assert(func)
    local new = Map2D:new()
    for y_key, row in pairs(self._map) do
        for x_key, val in pairs(row) do
            new:set(x_key, y_key, func(val))
        end
    end
    return new
end

function Map2D:adjacent(pos)
    local nbs = {}
    for _, diff in pairs({
        { x = 0,  y = 1 },
        { x = 0,  y = -1 },
        { x = 1,  y = 0 },
        { x = -1, y = 0 },
    }) do
        local tx = pos.x + diff.x
        local ty = pos.y + diff.y
        local val = self:get(tx, ty)
        if val ~= nil then
            table.insert(nbs, { x = tx, y = ty, val = val })
        end
    end
    return nbs
end

return Map2D
