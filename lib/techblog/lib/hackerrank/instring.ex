defmodule Techblog.Hackerrank.Instring do
  @moduledoc """
  A problem from
  https://www.hackerrank.com/challenges/hackerrank-in-a-string/problem

  We say that a string contains the word `hackerrank` if a subsequence of its
  characters spell the word hackerrank.

  For example, if string `s = haacckkerrannnkk` it does contain `hackerrank`,
  but `s = hccaakkerrannkk` does not.

  In the second case, the second `r` is missing.

  If we reorder the first string as `s = hccaakkerrannkk`,
  it no longer contains the subsequence due to ordering.
  """

  @doc """
  Enter your code here. Read input from STDIN. Print output to STDOUT
  """
  def go() do
    looking_for = "hackerrank"
    num_queries = input(:int)

    for _ <- 1..num_queries do
      input(:string)
      |> is_a_string(looking_for)
      |> case do
        true -> IO.puts("YES")
        false -> IO.puts("NO")
      end
    end
  end

  @doc """
  Determine if the provided needed is "somewhere" in the hackstack
  (so all the letters present and in the "correct" order, possibly with
  other letters around it

  ### Examples

      iex> is_a_string("haacckkerrannnkk", "hackerrank")
      true

      iex> is_a_string("hccaakkerrannkk", "hackerrank")
      false

      iex> is_a_string("hccaakkerrannkk", "hackerrank")
      false
  """
  def is_a_string(haystack, needle) do
    needle_list = String.codepoints(needle)
    needle_set = MapSet.new(needle_list)

    haystack_indexes =
      haystack
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {letter, index}, letter_map ->
        if MapSet.member?(needle_set, letter) do
          Map.update(letter_map, letter, [index], &(&1 ++ [index]))
        else
          letter_map
        end
      end)

    needle_list
    |> Enum.reduce_while(-1, fn letter, last_index ->
      if indexes = haystack_indexes[letter] do
        Enum.find(indexes, fn my_index -> my_index > last_index end)
      end
      |> case do
        nil -> {:halt, nil}
        my_index -> {:cont, my_index}
      end
    end)
    |> case do
      nil -> false
      _found -> true
    end
  end

  defp input(:string), do: IO.read(:line) |> String.trim()
  defp input(:int), do: input(:string) |> String.to_integer()
end
