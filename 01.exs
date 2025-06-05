{:ok, content} = File.read("01.txt")
# content = "3   4
# 4   3
# 2   5
# 1   3
# 3   9
# 3   3"

IO.puts("A:")
content |> String.split("\n", trim: true)
|> Enum.map(fn x -> String.split(x) end)
|> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
|> Enum.unzip()
|> then(fn {l, r} -> {Enum.sort(l), Enum.sort(r)} end)
|> then(fn {l, r} -> Enum.zip(l, r) end)
|> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
|> IO.inspect()

IO.puts("B:")
{l, r} = content |> String.split("\n", trim: true)
|> Enum.map(fn x -> String.split(x) end)
|> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
|> Enum.unzip()
|> IO.inspect()
freq = Enum.frequencies(r)
l |> Enum.map(fn x -> x * Map.get(freq, x, 0) end)
|> Enum.sum
|> IO.inspect()
