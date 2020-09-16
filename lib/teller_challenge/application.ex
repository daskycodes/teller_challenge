defmodule TellerChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TellerChallengeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TellerChallenge.PubSub},
      # Start the Endpoint (http/https)
      TellerChallengeWeb.Endpoint
      # Start a worker by calling: TellerChallenge.Worker.start_link(arg)
      # {TellerChallenge.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TellerChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TellerChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
