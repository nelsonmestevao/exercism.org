defmodule LanguageList do
  def new(), do: []

  def add(list, language), do: [language | list]

  def remove([]), do: []
  def remove([_head | tail]), do: tail

  def first([]), do: nil
  def first([head | _tail]), do: head

  def count([]), do: 0

  def count([_head | tail]) do
    1 + count(tail)
  end

  def functional_list?([]), do: false
  def functional_list?(["Elixir" | _tail]), do: true

  def functional_list?([_head | tail]) do
    functional_list?(tail)
  end
end
