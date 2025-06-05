{:ok, content} = File.read("02.txt")
# content = "7 6 4 2 1
# 1 2 7 8 9
# 9 7 6 2 1
# 1 3 2 4 5
# 8 6 4 4 1
# 1 3 6 7 9
# 0 6 7 8 9
# 79 81 82 83 87 89 92 92
# 9 12 13 16 15 16 19"

defmodule Report do
  def is_safe_with_tolerance_2(row) do
    Enum.with_index(row)
    |> Enum.map(fn {_val, idx} -> is_safe(List.delete_at(row, idx)) end)
    |> Enum.any?()
  end

  def is_safe_with_tolerance(row) do
    idx1 =
      Enum.find_index(map_offenders(row, &Report.is_el_up/2), fn
        _x = true -> false
        _x = false -> true
      end)

    idx2 =
      Enum.find_index(map_offenders(row, &Report.is_el_down/2), fn
        _x = true -> false
        _x = false -> true
      end)

    # IO.inspect("#{idx1}, #{idx2}")
    case {idx1, idx2} do
      {nil, _} ->
        true

      {_, nil} ->
        true

      _ ->
        # we need to try removing the "offending" element, but we don't know if it's
        # at idx or idx-1
        # if idx is 0, this will remove the last element (-1), which isn't useful,
        # but doesn't hurt - the check is not needed but will still returns correct value;
        # this saves special casing for idx1 or idx2 being zero
        is_safe(List.delete_at(row, idx1)) or is_safe(List.delete_at(row, idx2)) or
          is_safe(List.delete_at(row, idx1 - 1)) or is_safe(List.delete_at(row, idx2 - 1))
    end
  end

  def is_el_up(prev, current) do
    current - prev > 0 and current - prev < 4
  end

  def is_el_down(prev, current) do
    current - prev < 0 and current - prev > -4
  end

  def map_offenders(row, comp) do
    {mapped, _last} =
      Enum.map_reduce(row, :none, fn
        # first item has no previous
        curr, :none ->
          # output, new_state
          {true, curr}

        curr, prev ->
          {comp.(prev, curr), curr}
      end)

    mapped
  end

  def is_safe_4(row) do
    # alternative implementation of is_safe
    # should always give the same results as is_safe
    diffs =
      Enum.chunk_every(row, 2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    is_up = Enum.all?(diffs, fn x -> x > 0 end)
    is_down = Enum.all?(diffs, fn x -> x < 0 end)
    is_monotonic = is_up or is_down

    max =
      Enum.map(diffs, &abs/1)
      |> Enum.max()

    max < 4 and is_monotonic
  end

  def is_safe_3(row) do
    # alternative implementation of is_safe
    # should always give the same results as is_safe
    is_up(row) or is_up(Enum.reverse(row))
  end

  def is_safe_2(row) do
    # alternative implementation of is_safe
    # should always give the same results as is_safe
    idx1 =
      Enum.find_index(map_offenders(row, &Report.is_el_up/2), fn
        _x = true -> false
        _x = false -> true
      end)

    idx2 =
      Enum.find_index(map_offenders(row, &Report.is_el_down/2), fn
        _x = true -> false
        _x = false -> true
      end)

    idx1 == nil or idx2 == nil
  end

  def is_up(row) do
    [head | row] = row

    {ok, _} =
      Enum.reduce(row, {true, head}, fn el, {ok, prev} ->
        {ok and el - prev > 0 and el - prev < 4, el}
      end)

    ok
  end

  def is_down(row) do
    [head | row] = row

    {ok, _} =
      Enum.reduce(row, {true, head}, fn el, {ok, prev} ->
        {ok and el - prev < 0 and el - prev > -4, el}
      end)

    ok
  end

  def is_safe(row) do
    is_up(row) or is_down(row)
  end
end

lines =
  content
  |> String.split("\n", trim: true)
  |> Enum.map(fn x ->
    String.split(x)
    |> Enum.map(&String.to_integer/1)
  end)

# all decreasing or all increasing
# diff 1, 2 or 3
IO.puts("A:")

lines
|> Enum.map(&Report.is_safe/1)
|> Enum.sum_by(fn x -> if x, do: 1, else: 0 end)
|> IO.inspect()

lines
|> Enum.map(&Report.is_safe_2/1)
|> Enum.sum_by(fn x -> if x, do: 1, else: 0 end)
|> IO.inspect()

lines
|> Enum.map(&Report.is_safe_3/1)
|> Enum.sum_by(fn x -> if x, do: 1, else: 0 end)
|> IO.inspect()

lines
|> Enum.map(&Report.is_safe_4/1)
|> Enum.sum_by(fn x -> if x, do: 1, else: 0 end)
|> IO.inspect()

# 476
IO.puts("B:")

per_row =
  lines
  |> Enum.map(&Report.is_safe_with_tolerance/1)

per_row
|> Enum.sum_by(fn x -> if x, do: 1, else: 0 end)
|> IO.inspect()

per_row_2 =
  lines
  |> Enum.map(&Report.is_safe_with_tolerance_2/1)

per_row_2
|> Enum.sum_by(fn x -> if x, do: 1, else: 0 end)
|> IO.inspect()

Enum.zip_with([lines, per_row, per_row_2], fn
  [input, l, r] when l != r -> input
  _ -> nil
end)
|> Enum.reject(&is_nil/1)
|> IO.inspect(label: "diff", charlists: :as_lists)
