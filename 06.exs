map_raw = "
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"
map_raw = File.read!("06.txt")

guard_dir = :up

# Parse into %{ {x, y} => char }
map_lines = String.split(map_raw, "\n", trim: true)

{map, guard_pos} =
  Enum.with_index(map_lines)
  |> Enum.reduce({%{}, nil}, fn {line, y}, {acc_map, arrow} ->
    Enum.with_index(String.graphemes(line))
    |> Enum.reduce({acc_map, arrow}, fn {char, x}, {map_acc, arrow_acc} ->
      new_map = Map.put(map_acc, {x, y}, char)

      new_arrow =
        if char == "^" do
          {x, y}
        else
          arrow_acc
        end

      {new_map, new_arrow}
    end)
  end)

defmodule Maze do
  def rotate(dir) do
    case dir do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  def step({map, {guard_x, guard_y}, guard_dir}) do
    next_pos_target =
      case guard_dir do
        :up -> {guard_x, guard_y - 1}
        :down -> {guard_x, guard_y + 1}
        :left -> {guard_x - 1, guard_y}
        :right -> {guard_x + 1, guard_y}
      end

    next_tile = Map.get(map, next_pos_target, nil)

    {next_pos_actual, next_dir} =
      case next_tile do
        nil -> {nil, guard_dir}
        "#" -> {{guard_x, guard_y}, rotate(guard_dir)}
        "." -> {next_pos_target, guard_dir}
      end

    map = Map.put(map, {guard_x, guard_y}, ".")
    map = Map.put(map, next_pos_actual, "^")
    # IO.inspect(next_pos_actual, label: "Guard Position")
    {map, next_pos_actual, next_dir}
  end

  def step_all({_, nil, _}, occupied) do
    MapSet.size(occupied)
  end

  def step_all(state, occupied) do
    {_, pos, _} = state
    occupied = MapSet.put(occupied, pos)
    next_state = step(state)
    step_all(next_state, occupied)
  end
end

# IO.inspect(guard_pos, label: "Guard Position")
{map, guard_pos, guard_dir}
|> Maze.step_all(MapSet.new())
|> IO.inspect(label: "A")
