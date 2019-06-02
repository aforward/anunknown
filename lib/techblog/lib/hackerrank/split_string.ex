defmodule Techblog.Hackerrank.SplitString do
  @moduledoc """
  A problem from
  https://www.hackerrank.com/challenges/30-review-loop/problem

  Given a string, S, of length N that is indexed from 0 to N-1,
  print its even-indexed and odd-indexed characters as 2
  space-separated strings on a single line .
  """

  @doc """
  Enter your code here. Read input from STDIN. Print output to STDOUT
  """
  def go() do
    for _ <- 1..input(:int) do
      input(:string)
      |> split_string()
      |> print_string()
    end
  end

  @doc """
  Split a line of code into two parts first the even-indexed (0, 2, ...)
  and the second the odd-indexed (1, 3, ...)

  ### Examples

    iex> split_string("Hacker")
    ["Hce", "akr"]

    iex> split_string("Rank")
    ["Rn", "ak"]

    iex> split_string("")
    ["", ""]

    iex> split_string("a")
    ["a", ""]
  """
  def split_string(line) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(["", ""], fn {letter, index}, [even, odd] ->
      case rem(index, 2) do
        0 -> [even <> letter, odd]
        1 -> [even, odd <> letter]
      end
    end)
  end

  def print_string([a, b]), do: IO.puts("#{a} #{b}")

  def input(:string), do: IO.read(:line) |> String.trim()
  def input(:int), do: input(:string) |> String.to_integer()
end
