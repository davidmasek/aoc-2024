operators_raw =
  "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

args = Args.parse()

lines =
  Input.load(operators_raw, "07.txt", args)
  |> Input.lines()

operations_A = [
  &Kernel.+/2,
  &Kernel.*/2
]

operations_B = [
  &Kernel.+/2,
  &Kernel.*/2,
  &Combinator.concat_ints/2
]

defmodule Combinator do
  def concat_ints(a, b) do
    (Integer.to_string(a) <> Integer.to_string(b))
    |> String.to_integer()
  end

  def count_combinations(target, numbers, operations) do
    [first | tail] = numbers
    _count(target, tail, first, operations)
  end

  def _count(target, [next | tail], acc, operations) do
    Enum.map(operations, fn op ->
      _count(target, tail, op.(acc, next), operations)
    end)
    |> Enum.sum()
  end

  def _count(target, [], acc, _operations) do
    if target == acc do
      1
    else
      0
    end
  end
end

inputs =
  lines
  |> Enum.map(fn line ->
    [l, r] = String.split(line, ":")
    l = String.to_integer(l)

    r =
      String.split(r)
      |> Enum.map(&String.to_integer/1)

    {l, r}
  end)

combinations_A =
  inputs
  |> Enum.map(fn {target, numbers} ->
    {target, Combinator.count_combinations(target, numbers, operations_A)}
  end)
  |> Debug.inspect(args)

for {result, count} <- combinations_A, count != 0 do
  result
end
|> Enum.sum()
|> IO.inspect(label: "A")

combinations_B =
  inputs
  |> Enum.map(fn {target, numbers} ->
    {target, Combinator.count_combinations(target, numbers, operations_B)}
  end)

for {result, count} <- combinations_B, count != 0 do
  result
end
|> Enum.sum()
|> IO.inspect(label: "B")
