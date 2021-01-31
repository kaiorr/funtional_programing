defmodule Conta do
  defstruct usuario: Usuario, saldo: 1000
  @contas "contas.txt"

  def cadastrar(usuario) do
    contas = buscar_contas()

     binary = [%__MODULE__{usuario: usuario}] ++ buscar_contas()
     |> :erlang.term_to_binary()
     File.write(@contas, binary)
  end

  defp buscar_por_email(email), do: Enum.find(buscar_contas(), &(&1.usuario.email == email) fn c -> c.usuario.email == email end)

  def buscar_contas do
    {:ok, binary} = File.read(@contas)
    :erlang.binary_to_term(binary)
  end

  def transferir(contas, de, para, valor) do
    de = Enum.find(contas, fn conta -> conta.usuario.email == de.usuario.email end)

    cond do
      valida_saldo(de.saldo, valor) -> {:error, "Saldo insuficiente!"}
      true ->
        para = Enum.find(contas, fn conta -> conta.usuario.email == para.usuario.email end)
        de = %Conta{de | saldo: de.saldo - valor}
        para = %Conta{para | saldo: para.saldo + valor}
      [de, para]
    end
  end

  def sacar(conta, valor) do
    cond do
      valida_saldo(conta.saldo, valor) -> {:error, "Saldo Insuficiente"}
      true ->
        conta = %Conta{conta | saldo: conta.saldo - valor}
        {:ok, conta, "mensagem de email encaminhada"}
      end
  end

  defp valida_saldo(saldo, valor), do: saldo < valor

end
