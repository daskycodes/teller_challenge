defmodule TellerChallengeWeb.MetricsTest do
  use ExUnit.Case, async: true

  alias TellerChallengeWeb.Metrics

  setup do
    timestamp = :os.system_time(:seconds)
    requests = for offset <- 1..5, do: %{timestamp: timestamp - offset, path: "/accounts"}
    [requests: requests, timestamp: timestamp]
  end

  test "handle_cast({:push, path}), state) returns last 6 seconds worth of requests", context do
    {:noreply, state} = Metrics.handle_cast({:push, "/accounts"}, context.requests)

    assert Enum.count(state) == 6

    assert state ==
             for(offset <- 0..5, do: %{path: "/accounts", timestamp: context.timestamp - offset})
  end
end
