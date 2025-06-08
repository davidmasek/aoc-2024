{:ok, content} = File.read("03.txt")

rex = ~r/mul\((\d{1,3}),(\d{1,3})\)|don't\(\)|do\(\)/

multiply = fn content, label ->
  Regex.scan(rex, content)
  |> IO.inspect()
  |> Enum.reduce(
    {0, true},
    fn match, {total, enabled} ->
      case match do
        ["do()"] -> {total, true}
        ["don't()"] when label == "B" -> {total, false}
        # ignore don't in part A
        ["don't()"] when label == "A" -> {total, true}
        [_, a, b] when enabled -> {total + String.to_integer(a) * String.to_integer(b), enabled}
        [_, _, _] -> {total, enabled}
      end
    end
  )
  |> elem(0)
  |> IO.inspect(label: label)
end

multiply.(content, "A")
multiply.(content, "B")
