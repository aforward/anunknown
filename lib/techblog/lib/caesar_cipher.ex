defmodule Techblog.CaesarCipher do
  @moduledoc """
  A problem from
  https://www.hackerrank.com/challenges/caesar-cipher-1/problem

  Julius Caesar protected his confidential information by encrypting
  it using a cipher. Caesar's cipher shifts each letter by a number
  of letters. If the shift takes you past the end of the alphabet,
  just rotate back to the front of the alphabet. In the case of a
  rotation by 3, w, x, y and z would map to z, a, b and c.
  """

  @doc """
  Enter your code here. Read input from STDIN. Print output to STDOUT
  """
  def go() do
    num = input(:int)
    text = input(:string)
    k = input(:int)
    IO.puts("#{encrypt(num, text, k)}")
  end

  @doc """
  Encyrpt using a Caesar cipher, moving the characters over "n" places

  ## Examples

    iex> Techblog.CaesarCipher.encrypt(1, "a", 0)
    "a"

    iex> Techblog.CaesarCipher.encrypt(1, "a", 26)
    "a"

    iex> Techblog.CaesarCipher.encrypt(1, "a", 52)
    "a"

    iex> Techblog.CaesarCipher.encrypt(1, "a", 1)
    "b"

    iex> Techblog.CaesarCipher.encrypt(1, "z", 1)
    "a"

    iex> Techblog.CaesarCipher.encrypt(1, "A", 0)
    "A"

    iex> Techblog.CaesarCipher.encrypt(1, "A", 26)
    "A"

    iex> Techblog.CaesarCipher.encrypt(1, "A", 52)
    "A"

    iex> Techblog.CaesarCipher.encrypt(1, "A", 1)
    "B"

    iex> Techblog.CaesarCipher.encrypt(1, "Z", 1)
    "A"

  """
  def encrypt(_num, text, raw_k) do
    k = rem(raw_k, 26)

    text
    |> String.to_charlist()
    |> Enum.map(fn c ->
      cond do
        c >= ?a && c <= ?z -> add(c, ?a, k)
        c >= ?A && c <= ?Z -> add(c, ?A, k)
        :else -> c
      end
    end)
    |> to_string()
  end

  defp add(unencrypted, base, k) do
    base + rem(unencrypted - base + k, 26)
  end

  defp input(:string), do: IO.read(:line) |> String.trim()
  defp input(:int), do: input(:string) |> String.to_integer()
end
