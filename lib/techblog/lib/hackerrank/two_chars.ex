defmodule Techblog.Hackerrank.TwoChars do
  @moduledoc """
  A problem from
  https://www.hackerrank.com/challenges/two-characters/problem

  Given a string, convert it to the longest possible string
  made up only of alternating characters. Print the length of
  string  on a new line. If no string  can be formed, print instead.
  """

  @doc """
  Enter your code here. Read input from STDIN. Print output to STDOUT
  """
  def go() do
    num = input(:int)
    text = input(:string)
    IO.puts("#{two_characters(num, text)}")
  end

  @doc """
  Take a string (and it's length more based on the requirements
  of the call) and return the longer string based on a sequence
  of two characters

  ## Examples

      iex> two_characters(1, "a")
      0

      iex> two_characters(2, "aa")
      0

      iex> two_characters(12, "aaaaaaaaaaaa")
      0

      iex> two_characters(2, "ab")
      2

      iex> two_characters(3, "abc")
      2

      iex> two_characters(10, "beabeefeab")
      5

      iex> two_characters(28, "asdcbsdcagfsdbgdfanfghbsfdab")
      8

      iex> two_characters(28, "asvkugfiugsalddlasguifgukvsa")
      0
  """
  def two_characters(_num, text) do
    text_chars = String.codepoints(text)
    all_chars = MapSet.new(text_chars)

    all_chars
    |> Enum.flat_map(fn a ->
      all_chars
      |> Enum.map(fn b ->
        sequence_length(text_chars, a, b)
      end)
    end)
    |> Enum.max()
  end

  @doc """
  Takes an enum of characters, and the two alternating
  characters to keep.  Return the longest repeating
  sequence you can find by removing all other characters.

  ## Examples

      iex> sequence_length(["a"], "b", "e")
      0

      iex> sequence_length(["b", "e"], "b", "e")
      2

      iex> sequence_length(["b", "a", "e"], "b", "e")
      2
  """
  def sequence_length(_text, a, a), do: 0

  def sequence_length(text, a, b) do
    text
    |> Enum.reduce({0, [a, b]}, fn c, {num, [x, y]} ->
      case c do
        ^x -> {num + 1, [y, x]}
        ^y -> {0, [nil, nil]}
        _ -> {num, [x, y]}
      end
    end)
    |> (fn {num, _} -> num end).()
  end

  def input(:string), do: IO.read(:line) |> String.trim()
  def input(:int), do: input(:string) |> String.to_integer()
end
