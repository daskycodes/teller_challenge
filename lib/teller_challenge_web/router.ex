defmodule TellerChallengeWeb.Router do
  use TellerChallengeWeb, :router
  alias TellerChallenge.Authentication.User

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TellerChallengeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :bump_metric
  end

  pipeline :auth do
    plug :basic_auth
  end

  scope "/accounts", TellerChallengeWeb do
    pipe_through :api
    pipe_through :basic_auth

    get "/", AccountController, :index
    get "/:account_id", AccountController, :show
    get "/:account_id/transactions", TransactionController, :index
    get "/:account_id/transactions/:transaction_id", TransactionController, :show
  end

  scope "/", TellerChallengeWeb do
    pipe_through :browser

    live "/", DashboardLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TellerChallengeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TellerChallengeWeb.Telemetry
    end
  end

  defp basic_auth(conn, _opts) do
    with {api_token, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         %User{} = user <- TellerChallenge.Authentication.find_by_api_token(api_token, pass) do
      assign(conn, :current_user, user)
    else
      {:error, message} ->
        conn |> put_status(:unauthorized) |> json(%{error: message}) |> halt()

      _ ->
        conn |> put_status(:unauthorized) |> json(%{error: "Unauthorized"}) |> halt()
    end
  end

  defp bump_metric(conn, _opts) do
    register_before_send(conn, fn conn ->
      if conn.status == 200 do
        path = "/" <> Enum.join(conn.path_info, "/")
        TellerChallengeWeb.Metrics.bump(path)
      end

      conn
    end)
  end
end
