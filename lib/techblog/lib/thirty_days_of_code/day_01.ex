defmodule Techblog.ThirtyDaysOfCode.Day01 do
  def go() do
    text = input()
    IO.puts("Hello, World.")
    IO.puts(text)
  end

  def input(), do: IO.read(:line) |> String.trim()
end
