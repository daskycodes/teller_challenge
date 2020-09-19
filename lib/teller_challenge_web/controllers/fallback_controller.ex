defmodule TellerChallengeWeb.FallbackControler do
  use TellerChallengeWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TellerChallengeWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(TellerChallengeWeb.ErrorView)
    |> render(:"403")
  end
end
