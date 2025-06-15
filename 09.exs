# inputs =
#   "2333133121414131402"
inputs =
  File.read!("09.txt")
  |> String.graphemes()
  |> Enum.map(&String.to_integer/1)

files =
  inputs
  |> Enum.take_every(2)

n_files =
  files
  |> Enum.sum()

spaces =
  inputs
  |> Enum.drop_every(2)

seq =
  files
  |> Enum.with_index()
  |> Enum.flat_map(fn {size, index} -> List.duplicate(index, size) end)
  |> IO.inspect(label: "seq")

rev =
  seq
  |> Enum.reverse()

defmodule Spacer do
  def take([], _is_file, fs, _seq, _rev) do
    fs
    |> Enum.reverse()
  end

  def take(inputs, is_file, fs, seq, rev) do
    [how_many | inputs] = inputs

    {fs, seq, rev} =
      if is_file do
        new = Enum.take(seq, how_many)
        fs = Enum.reverse(new) ++ fs
        seq = Enum.drop(seq, how_many)
        {fs, seq, rev}
      else
        new = Enum.take(rev, how_many)
        fs = Enum.reverse(new) ++ fs
        rev = Enum.drop(rev, how_many)
        {fs, seq, rev}
      end

    take(inputs, !is_file, fs, seq, rev)
  end
end

Spacer.take(inputs, true, [], seq, rev)
|> Enum.take(n_files)
|> Enum.with_index()
|> Enum.map(fn {id, index} -> id * index end)
|> Enum.sum()
|> IO.inspect()
