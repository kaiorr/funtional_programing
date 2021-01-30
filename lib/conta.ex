defmodule Conta do
  defstruct usuario: Usuario, saldo: 1000

  def cadastrar(usuario), do: %__MODULE__{usuario: usuario}

end
