defmodule Input do
  def load(short_input, file, args) do
    if args.full do
      File.read!(file)
    else
      short_input
    end
  end

  def lines(input) do
    String.trim(input)
    |> String.split("\n")
  end
end
