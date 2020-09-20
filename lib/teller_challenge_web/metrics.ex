defmodule TellerChallengeWeb.Metrics do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:push, path}, state) do
    timestamp = :os.system_time(:seconds)
    api_request = %{timestamp: timestamp, path: path}
    # keep last 5 seconds of requests in state
    state = Enum.take_while(state, &(&1.timestamp != timestamp - 6))
    {:noreply, [api_request | state]}
  end

  @impl true
  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end

  def read() do
    GenServer.call(__MODULE__, :read)
  end

  def bump(path) when is_binary(path) do
    GenServer.cast(__MODULE__, {:push, path})
  end
end
