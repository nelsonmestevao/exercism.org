defmodule Markdown do
  @moduledoc false

  @doc ~S"""
  Parses a given string with Markdown syntax and returns the associated HTML for that string.

  ## Examples

  iex> Markdown.parse("This is a paragraph")
  "<p>This is a paragraph</p>"

  iex> Markdown.parse("# Header!\n* __Bold Item__\n* _Italic Item_")
  "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(text) do
    text
    |> String.split("\n")
    |> Enum.map_join(&process/1)
    |> String.replace("<li>", "<ul>" <> "<li>", global: false)
    |> String.replace_suffix("</li>", "</li>" <> "</ul>")
  end

  defp process("#" <> _ = t), do: enclose_with_header_tag(parse_header_md_level(t))
  defp process("*" <> _ = t), do: parse_list_md_level(t)
  defp process(t), do: enclose_with_paragraph_tag(String.split(t))

  defp parse_header_md_level(hwt) do
    [h | t] = String.split(hwt)
    {to_string(String.length(h)), Enum.join(t, " ")}
  end

  defp enclose_with_header_tag({level, text}) do
    "<h" <> level <> ">" <> text <> "</h" <> level <> ">"
  end

  defp parse_list_md_level(l) do
    t = String.split(String.trim_leading(l, "* "))
    "<li>" <> join_words_with_tags(t) <> "</li>"
  end

  defp enclose_with_paragraph_tag(t) do
    "<p>#{join_words_with_tags(t)}</p>"
  end

  defp join_words_with_tags(t) do
    Enum.map_join(t, " ", fn w -> replace_md_with_tag(w) end)
  end

  defp replace_md_with_tag(w) do
    replace_suffix_md(replace_prefix_md(w))
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end
end
