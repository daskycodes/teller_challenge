defmodule TellerChallengeWeb.AccountControllerTest do
  use TellerChallengeWeb.ConnCase, async: true
  import TestHelper

  @api_token random_api_token()
  @account_id account_id_from_api_token(@api_token)
  @unauthorized_api_token random_api_token()

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns status code 200 with valid api token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> get(Routes.account_path(conn, :index))

      assert json_response(conn, 200)
    end

    test "returns status code 401 without authorization header", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index))

      assert json_response(conn, 401)
    end
  end

  describe "show" do
    test "renders single account when authorized", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> get(Routes.account_path(conn, :show, @account_id))

      assert %{} = json_response(conn, 200)
    end

    test "renders status code 403 when api_token does not match acount id", %{conn: conn} do
      conn =
        conn
        |> put_req_header(
          "authorization",
          "Basic " <> Base.encode64("#{@unauthorized_api_token}:")
        )
        |> get(Routes.account_path(conn, :show, @account_id))

      assert json_response(conn, 403)
    end
  end
end
