defmodule TellerChallengeWeb.DashboardLiveTest do
  use TellerChallengeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Sandbox Token:"
    assert render(page_live) =~ "Sandbox Token:"
  end
end
