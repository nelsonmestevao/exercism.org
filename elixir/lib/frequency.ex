defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _workers), do: %{}

  def frequency(texts, workers) do
    chunks = ceil(length(texts) / workers)

    texts
    |> Enum.chunk_every(chunks)
    |> Enum.map(&Task.async(fn -> frequency(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(%{}, fn e, acc ->
      Map.merge(acc, e, fn _k, v1, v2 ->
        v1 + v2
      end)
    end)
  end

  def frequency(texts) do
    texts
    |> Enum.join()
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&Regex.match?(~r/[[:alpha:]]/, &1))
    |> Enum.frequencies()
  end
end
