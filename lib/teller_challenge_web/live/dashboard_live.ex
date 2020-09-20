defmodule TellerChallengeWeb.DashboardLive do
  use TellerChallengeWeb, :live_view
  import TellerChallengeWeb.Helpers
  alias TellerChallengeWeb.Router.Helpers, as: Routes
  alias TellerChallengeWeb.Endpoint

  @impl true
  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :next_requests)

    {:ok,
     assign(socket,
       requests: requests(),
       api_token: generate_api_token(),
       entrypoint: Routes.account_url(Endpoint, :index),
       pagination:
         Routes.transaction_url(Endpoint, :index, :account_id, %{
           count: 5,
           from_id: :txn_id
         })
     )}
  end

  @impl true
  def handle_info(:next_requests, socket) do
    {:noreply, assign(socket, requests: requests())}
  end

  defp requests() do
    requests_for_last_seconds(5)
    |> Enum.reverse()
    |> Jason.encode!()
  end

  defp requests_for_last_seconds(seconds) do
    timestamp = :os.system_time(:seconds)

    for seconds <- 1..seconds do
      requests = Enum.filter(metrics(), &(&1.timestamp == timestamp - seconds))
      [timestamp - seconds, Enum.count(requests)]
    end
  end

  defp metrics() do
    TellerChallengeWeb.Metrics.read()
  end
end
