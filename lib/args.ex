defmodule Args do
  defstruct full: false, debug: false

  def parse(args \\ System.argv()) do
    args =
      args
      |> OptionParser.parse(
        strict: [full: :boolean, debug: :boolean, help: :boolean],
        aliases: [d: :debug, f: :full, h: :help]
      )
      # only correctly parsed args
      |> elem(0)

    if args[:help] do
      IO.puts("Usage: mix run <script> [-f|--full] [-d|--debug] [-h|--help]")
    end

    args = %Args{
      debug: args[:debug],
      full: args[:full]
    }

    if args.debug do
      IO.inspect(args, label: "args")
    end

    args
  end
end
