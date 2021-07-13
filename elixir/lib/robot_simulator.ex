defmodule RobotSimulator do
  @moduledoc false

  defmodule Robot do
    @moduledoc false
    defstruct(direction: :north, position: {0, 0})
  end

  defguard is_direction(direction) when direction in [:north, :east, :south, :west]
  defguard is_position(x, y) when is_integer(x) and is_integer(y)

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create, do: %Robot{}
  def create(direction, _) when not is_direction(direction), do: {:error, "invalid direction"}

  def create(direction, {x, y}) when is_position(x, y),
    do: %Robot{direction: direction, position: {x, y}}

  def create(_, _), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, "") do
    robot
  end

  def simulate(%Robot{direction: direction, position: position}, instructions) do
    {first, rest} = String.split_at(instructions, 1)

    case first do
      "R" ->
        %Robot{direction: right(direction), position: position} |> simulate(rest)

      "L" ->
        %Robot{direction: left(direction), position: position} |> simulate(rest)

      "A" ->
        %Robot{direction: direction, position: avance(direction, position)}
        |> simulate(rest)

      _ ->
        {:error, "invalid instruction"}
    end
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%Robot{} = robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%Robot{} = robot) do
    robot.position
  end

  defp avance(direction, {x, y}) do
    case direction do
      :north -> {x, y + 1}
      :east -> {x + 1, y}
      :south -> {x, y - 1}
      :west -> {x - 1, y}
    end
  end

  defp right(direction) do
    case direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end

  defp left(direction) do
    case direction do
      :north -> :west
      :east -> :north
      :south -> :east
      :west -> :south
    end
  end
end
