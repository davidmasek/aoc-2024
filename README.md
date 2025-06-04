# ElixirOfCode

Advent of Code 2024 in Elixir.

Quick links:
- https://adventofcode.com/2024
- https://elixir-lang.org/
- https://hexdocs.pm/elixir/introduction.html


```elixir
IO.inspect("hi")
```

## Run

```sh
# mix run 01.exs
mix run <script>

# elixir run 02.exs
elixir run <script>
```

## Installing VSCode extension

Install https://github.com/elixir-lsp/elixir-ls from extensions panel as usual.

It may crash when installing language server due to certificate issues.
Go to `~/.vscode/extensions/jakebecker.elixir-ls-0.28.0/elixir-ls-release` (or similar)
and install it manually in unsafe mode:
```sh
HEX_UNSAFE_HTTPS=1 ./launch.sh
```

Restart VSCode and it should work.
