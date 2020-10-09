defmodule TellerChallenge.IdempotencyKeyStore do
  use GenServer
  alias TellerChallenge.Banking.Transfer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:check, transfer}, _from, state) do
    %Transfer{source_account_id: source_account_id, idempotency_key: idempotency_key} = transfer
    key = {source_account_id, idempotency_key}

    case Map.fetch(state, key) do
      :error ->
        new_state = Map.put(state, key, transfer)
        {:reply, {:ok, transfer}, new_state}

      {:ok, value} ->
        {:reply, {:exists, value}, state}
    end
  end

  def check_if_idempotency_key_is_unused(transfer) do
    GenServer.call(__MODULE__, {:check, transfer})
  end
end
