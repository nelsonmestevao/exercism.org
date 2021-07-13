defmodule Queens do
  @moduledoc false

  @type t :: %__MODULE__{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  defguard valid?(a, b) when 0 <= a and a <= 7 and 0 <= b and b <= 7

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(positions \\ []) do
    case {positions[:white], positions[:black]} do
      {{a, b}, nil} when valid?(a, b) ->
        %__MODULE__{white: {a, b}}

      {nil, {a, b}} when valid?(a, b) ->
        %__MODULE__{black: {a, b}}

      {{a, b}, {c, d}} when {a, b} != {c, d} and valid?(a, b) and valid?(c, d) ->
        %__MODULE__{white: {a, b}, black: {c, d}}

      _ ->
        raise ArgumentError
    end
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    for i <- 0..7 do
      for j <- 0..7 do
        cond do
          {i, j} == queens.white -> "W"
          {i, j} == queens.black -> "B"
          true -> "_"
        end
      end
      |> Enum.join(" ")
    end
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: {wx, wy} = pos_w, black: {bx, by} = pos_b}) do
    bx == wx or by == wy or on_diagonal?(pos_w, pos_b)
  end

  def can_attack?(_queens), do: false

  defp on_diagonal?({wx, wy}, {bx, by}) do
    abs(wx - bx) == abs(wy - by)
  end
end
