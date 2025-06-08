content = File.read!("05.txt")
# content = "47|53
# 97|13
# 97|61
# 97|47
# 75|29
# 61|13
# 75|53
# 29|13
# 97|29
# 53|29
# 61|53
# 97|53
# 61|29
# 47|13
# 75|47
# 97|75
# 47|61
# 75|61
# 47|29
# 75|13
# 53|13

# 75,47,61,53,29
# 97,61,53,29,13
# 75,29,13
# 75,97,47,61,53
# 61,13,29
# 97,13,75,29,47
# "

[rules, updates] = String.split(content, "\n\n", trim: true)

defmodule Order do
  def is_valid(rules, existing_updates, [next_update | remaining_updates]) do
    next_must_be_printed_before = Map.get(rules, next_update, [])

    invalid =
      existing_updates
      |> Enum.map(&(&1 in next_must_be_printed_before))

      # |> IO.inspect(label: next_update)
      |> Enum.any?()

    case invalid do
      true -> false
      false -> is_valid(rules, [next_update | existing_updates], remaining_updates)
    end
  end

  def is_valid(rules, _existing_updates = [], remaining_updates) do
    [head, updates] = remaining_updates
    is_valid(rules, [head], updates)
  end

  def is_valid(_rules, _existing_updates, _remaining_updates = []) do
    true
  end
end

rules =
  rules
  |> String.split()
  |> Enum.map(fn line ->
    line
    |> String.split("|")
    |> Enum.map(&String.to_integer/1)
  end)
  |> Enum.group_by(&List.first(&1), &List.last(&1))

# |> IO.inspect(charlists: :as_lists)

updates =
  updates
  |> String.split()
  |> Enum.map(fn line ->
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end)

# |> IO.inspect(charlists: :as_lists)

updates
|> Enum.map(fn updts ->
  valid = Order.is_valid(rules, [], updts)
  middle_idx = div(length(updts), 2)

  case valid do
    true -> Enum.at(updts, middle_idx)
    _ -> 0
  end
end)
|> IO.inspect(label: "A")
|> Enum.sum()
|> IO.inspect(label: "A")
