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
  # check validity and gradually build a valid sequence
  def is_valid(rules, existing_updates, [next_update | remaining_updates]) do
    next_must_be_printed_before = Map.get(rules, next_update, [])

    # find wrongly ordered numbers
    all_invalid =
      existing_updates
      |> Enum.map(&(&1 in next_must_be_printed_before))

    idx =
      all_invalid
      # reverse to get last index
      |> Enum.reverse()
      |> Enum.find_index(& &1)

    idx =
      case idx do
        nil -> 0
        _ -> length(all_invalid) - idx
      end

    # once invalid order is detected it will stay marked as such
    invalid = Enum.any?(all_invalid)

    existing_updates =
      List.insert_at(existing_updates, idx, next_update)

    {is_valid, list} = is_valid(rules, existing_updates, remaining_updates)
    {is_valid and !invalid, list}
  end

  def is_valid(rules, _existing_updates = [], remaining_updates) do
    [head, updates] = remaining_updates
    is_valid(rules, [head], updates)
  end

  def is_valid(_rules, existing_updates, _remaining_updates = []) do
    {true, existing_updates}
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
  |> IO.inspect(charlists: :as_lists)

updates =
  updates
  |> String.split()
  |> Enum.map(fn line ->
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end)

updates
|> Enum.map(fn updts ->
  {valid, ordered} = Order.is_valid(rules, [], updts)
  middle_idx = div(length(updts), 2)

  case valid do
    true -> %{A: Enum.at(updts, middle_idx), B: 0}
    _ -> %{A: 0, B: Enum.at(ordered, middle_idx)}
  end
end)
|> IO.inspect(label: ">>", charlists: :as_lists)
|> Enum.reduce(%{A: 0, B: 0}, fn %{A: a, B: b}, %{A: a_acc, B: b_acc} ->
  %{A: a + a_acc, B: b + b_acc}
end)
|> IO.inspect(label: ">")
