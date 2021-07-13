defmodule Bob do
  @moduledoc false

  @doc """
  Responds to different types of phrases

  ## Examples

    iex> Bob.hey("Tom-ay-to, tom-aaaah-to.")
    "Whatever."

    iex> Bob.hey("WATCH OUT!")
    "Whoa, chill out!"

    iex> Bob.hey("Does this cryogenic chamber make me look fat?")
    "Sure."

    iex> Bob.hey("")
    "Fine. Be that way!"

  """
  def hey(text) do
    cond do
      silence?(text) ->
        "Fine. Be that way!"

      question?(text) and shout?(text) ->
        "Calm down, I know what I'm doing!"

      shout?(text) ->
        "Whoa, chill out!"

      question?(text) ->
        "Sure."

      true ->
        "Whatever."
    end
  end

  defp silence?(sentence), do: String.trim(sentence) == ""

  defp shout?(sentence) do
    String.upcase(sentence) == sentence and sentence != String.downcase(sentence)
  end

  defp question?(sentence) do
    sentence |> String.trim() |> String.ends_with?("?")
  end
end
