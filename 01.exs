{:ok, content} = File.read("01.txt")
content |> String.split("\n", trim: true)
|> Enum.map(fn x -> String.split(x) end)
|> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
|> Enum.unzip()
|> then(fn {l, r} -> {Enum.sort(l), Enum.sort(r)} end)
|> then(fn {l, r} -> Enum.zip(l, r) end)
|> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
|> IO.inspect()


# koriandr a zakysana smetana
