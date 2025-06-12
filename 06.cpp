#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <functional>

using namespace std;

enum Direction
{
    UP = 0,
    RIGHT,
    DOWN,
    LEFT
};

Direction rotate(Direction dir)
{
    return static_cast<Direction>((dir + 1) % 4);
}

struct Position
{
    int x, y;
    bool operator==(const Position &other) const
    {
        return x == other.x && y == other.y;
    }
};

using Grid = vector<vector<bool>>;

// Move one step
pair<Position, Direction> step(const Grid &grid, Position pos, Direction dir)
{
    static const int dx[] = {0, 1, 0, -1};
    static const int dy[] = {-1, 0, 1, 0};

    int nx = pos.x + dx[dir];
    int ny = pos.y + dy[dir];

    if (ny < 0 || ny >= (int)grid.size() || nx < 0 || nx >= (int)grid[0].size())
        return {{-1, -1}, dir}; // Escaped

    bool is_blocked = grid[ny][nx];
    if (is_blocked)
    {
        return {pos, rotate(dir)};
    }
    else
    {
        return {{nx, ny}, dir};
    }
}

pair<vector<vector<bool>>, string> step_all(
    const Grid &grid, vector<vector<bool>> &occupied,
    vector<vector<vector<bool>>> &visited, Position start, Direction dir)
{
    while (true)
    {
        if (start.x == -1)
        {
            return {occupied, "escaped"};
        }

        if (!occupied[start.y][start.x])
        {
            occupied[start.y][start.x] = true;
        }

        if (visited[start.y][start.x][dir])
        {
            return {occupied, "looped"};
        }

        visited[start.y][start.x][dir] = true;

        tie(start, dir) = step(grid, start, dir);
    }
}

int main()
{
    vector<string> lines;
    ifstream infile("06.txt");
    string line;
    while (getline(infile, line))
    {
        if (!line.empty())
            lines.push_back(line);
    }

    if (lines.empty())
    {
        lines = {
            "....#.....",
            ".........#",
            "..........",
            "..#.......",
            ".......#..",
            "..........",
            ".#..^.....",
            "........#.",
            "#.........",
            "......#..."};
    }

    int h = lines.size();
    int w = lines[0].size();
    Grid grid(h, vector<bool>(w));
    Position start;

    for (int y = 0; y < h; ++y)
    {
        for (int x = 0; x < w; ++x)
        {
            if (lines[y][x] == '#')
            {
                grid[y][x] = true;
            }
            else if (lines[y][x] == '^')
            {
                start = {x, y};
                grid[y][x] = false;
            }
            else if (lines[y][x] == '.')
            {
                grid[y][x] = false;
            }
            else
            {
                runtime_error("bad tile");
            }
        }
    }

    vector<vector<bool>> occupied(h, vector<bool>(w, false));
    vector<vector<vector<bool>>> visited(h, vector<vector<bool>>(w, vector<bool>(4, false)));

    auto [occupied_map, _] = step_all(grid, occupied, visited, start, UP);

    int partA = 0;
    for (int y = 0; y < h; ++y)
        for (int x = 0; x < w; ++x)
            if (occupied_map[y][x])
                ++partA;

    cout << "A: " << partA << endl;

    int partB = 0;
    for (int y = 0; y < h; ++y)
    {
        for (int x = 0; x < w; ++x)
        {
            if (!occupied_map[y][x])
                continue;

            for (int y = 0; y < h; ++y)
            {
                for (int x = 0; x < w; ++x)
                {
                    occupied[y][x] = false;
                    for (int i = 0; i < 4; i++)
                    {
                        visited[y][x][i] = false;
                    }
                }
            }

            grid[y][x] = true;
            auto [_, result] = step_all(grid, occupied, visited, start, UP);
            if (result != "escaped")
                partB++;
            grid[y][x] = false; // revert
        }
    }

    cout << "B: " << partB << endl;
    return 0;
}
