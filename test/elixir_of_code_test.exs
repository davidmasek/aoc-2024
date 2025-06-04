defmodule ElixirOfCodeTest do
  use ExUnit.Case
  doctest ElixirOfCode

  test "greets the world" do
    assert ElixirOfCode.hello() == :world
  end
end
