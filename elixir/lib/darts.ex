defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    case target_from(x, y) do
      :outside -> 0
      :outer -> 1
      :middle -> 5
      :inner -> 10
    end
  end

  defp target_from(x, y) do
    r = distance(x, y)

    cond do
      r <= 1 -> :inner
      r <= 5 -> :middle
      r <= 10 -> :outer
      true -> :outside
    end
  end

  defp distance(x, y) do
    :math.sqrt(x * x + y * y)
  end
end
