defmodule ProteinTranslation do
  @moduledoc false

  @codons %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine"
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    rna
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.join/1)
    |> of_rna([])
  end

  @spec of_rna(list(String.t()), list({String.t()})) :: {atom, list(String.t())}
  def of_rna([], acc), do: {:ok, acc}

  def of_rna([codon | rna], acc) do
    case of_codon(codon) do
      {:ok, "STOP"} -> {:ok, acc}
      {:ok, protein} -> of_rna(rna, acc ++ [protein])
      {:error, "invalid codon"} -> {:error, "invalid RNA"}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) when is_map_key(@codons, codon) do
    {:ok, Map.get(@codons, codon)}
  end

  def of_codon(codon) when codon in ["UAA", "UAG", "UGA"] do
    {:ok, "STOP"}
  end

  def of_codon(_), do: {:error, "invalid codon"}
end
