defmodule Debug do
  def inspect(val, args, opts \\ []) do
    if args.debug do
      opts = Keyword.put_new(opts, :charlists, :as_lists)
      IO.inspect(val, opts)
    else
      val
    end
  end
end
