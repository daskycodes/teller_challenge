defmodule TellerChallengeWeb.MetricsTest do
  use ExUnit.Case, async: true

  alias TellerChallengeWeb.Metrics

  setup do
    timestamp = :os.system_time(:seconds)
    requests = for offset <- 1..5, do: %{timestamp: timestamp - offset, path: "/accounts"}
    [requests: requests]
  end

  test "handle_cast({:push, path}), state) returns last 5 seconds worth of requests", context do
    {:noreply, state} = Metrics.handle_cast({:push, "/accounts"}, context.requests)

    assert Enum.count(state) == 5
  end
end
