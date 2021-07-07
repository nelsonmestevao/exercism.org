defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @roman [
    {1_000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  @spec numeral(pos_integer) :: String.t()
  def numeral(0), do: ""

  def numeral(number) do
    {threshold, roman} = Enum.find(@roman, fn {n, _} -> number >= n end)

    roman <> numeral(number - threshold)
  end
end
