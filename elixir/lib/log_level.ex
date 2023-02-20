defmodule LogLevel do
  @log_levels %{
    0 => {:trace, false},
    1 => {:debug, true},
    2 => {:info, true},
    3 => {:warning, true},
    4 => {:error, true},
    5 => {:fatal, false}
  }

  def to_label(level, legacy?) do
    {type, available_in_legacy?} = Map.get(@log_levels, level, {:unknown, false})

    cond do
      legacy? and not available_in_legacy? -> :unknown
      true -> type
    end
  end

  def alert_recipient(level, legacy?) do
    label = to_label(level, legacy?)

    cond do
      label in [:error, :fatal] -> :ops
      label == :unknown and legacy? -> :dev1
      label == :unknown and !legacy? -> :dev2
      true -> false
    end
  end
end
