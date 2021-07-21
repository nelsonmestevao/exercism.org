defmodule Zipper do
  @type t :: %Zipper{
          value: any,
          left: BinTree.t() | nil,
          right: BinTree.t() | nil,
          trail: [{:left | :right, any, BinTree.t() | nil}]
        }
  defstruct [:value, :left, :right, trail: []]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(%BinTree{value: value, left: left, right: right}) do
    %Zipper{value: value, left: left, right: right}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{value: value, left: left, right: right, trail: []}) do
    %BinTree{value: value, left: left, right: right}
  end

  def to_tree(zipper) do
    zipper
    |> up
    |> to_tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(nil), do: nil
  def value(%Zipper{value: value}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{left: nil}), do: nil

  def left(%Zipper{value: value, left: left, right: right, trail: trail}) do
    tree =
      case right do
        nil -> nil
        _ -> %BinTree{value: right.value, left: right.left, right: right.right}
      end

    %Zipper{
      value: left.value,
      left: left.left,
      right: left.right,
      trail: [{:left, value, tree} | trail]
    }
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{right: nil}), do: nil

  def right(%Zipper{value: value, left: left, right: right, trail: trail}) do
    tree =
      case left do
        nil -> nil
        _ -> %BinTree{value: left.value, left: left.left, right: left.right}
      end

    %Zipper{
      value: right.value,
      left: right.left,
      right: right.right,
      trail: [{:right, value, tree} | trail]
    }
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(nil), do: nil

  def up(zipper) when length(zipper.trail) == 0, do: nil

  def up(%Zipper{value: value, left: left, right: right, trail: [{side, top, rest} | tail]}) do
    tree = %BinTree{value: value, left: left, right: right}

    case side do
      :left ->
        %Zipper{value: top, left: tree, right: rest, trail: tail}

      :right ->
        %Zipper{value: top, left: rest, right: tree, trail: tail}
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    %Zipper{zipper | value: value}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %Zipper{zipper | left: left}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %Zipper{zipper | right: right}
  end
end
