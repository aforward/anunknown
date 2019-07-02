defmodule Techblog.Hackerrank.BinaryOnes do
  @moduledoc """
  A problem from
  https://www.hackerrank.com/challenges/30-binary-numbers/problem

  Given a base-10 integer, n, convert it to binary (base-2).
  Then find and print the base-10 integer denoting the maximum
  number of consecutive 1's in n's binary representation.
  """

  @doc """
  Enter your code here. Read input from STDIN. Print output to STDOUT
  """
  def go(), do: input(:int) |> binary_ones() |> IO.puts()

  @doc """

  Example

      iex> binary_ones(1)
      1

      iex> binary_ones(2)
      1

      iex> binary_ones(3)
      2

      iex> binary_ones(4)
      1

      iex> binary_ones(5)
      1

      iex> binary_ones(6)
      2

      iex> binary_ones(7)
      3

      iex> binary_ones(8)
      1

      iex> binary_ones(13)
      2
  """
  def binary_ones(num), do: binary_ones(num, {0, 0})

  defp binary_ones(0, {longest_ones, _current_ones}), do: longest_ones

  defp binary_ones(n, {longest_ones, current_ones}) do
    current_ones =
      case rem(n, 2) do
        1 -> current_ones + 1
        0 -> 0
      end

    longest_ones =
      if current_ones > longest_ones do
        current_ones
      else
        longest_ones
      end

    binary_ones(div(n, 2), {longest_ones, current_ones})
  end

  defp input(:string), do: IO.read(:line) |> String.trim()
  defp input(:int), do: input(:string) |> String.to_integer()
end
