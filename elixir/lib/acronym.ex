defmodule Acronym do
  @moduledoc false

  @doc """
    Generate an acronym from a string.

    ## Examples

      iex> Acronym.abbreviate("This is a string")
      "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split(~r/[\s-_]|(?=[A-Z][a-z]+)/, trim: true)
    |> Enum.map(&String.first/1)
    |> Enum.map_join(&String.upcase/1)
  end
end
