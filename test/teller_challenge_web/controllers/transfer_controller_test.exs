defmodule TellerChallengeWeb.TransferControllerTest do
  use TellerChallengeWeb.ConnCase, async: true
  import TestHelper

  @api_token random_api_token()
  @account_id account_id_from_api_token(@api_token)
  @transaction_id transaction_id_from_account_id(@account_id)
  @unauthorized_api_token random_api_token()

  describe "create" do
    test "returns status code 200 with valid api token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> post(Routes.transfer_path(conn, :create, @account_id))

      assert json_response(conn, 200)
    end

    test "returns status code 401 without authorization header", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create, @account_id))

      assert json_response(conn, 401)
    end

    test "return status code 200 with unused idempotency key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> post(Routes.transfer_path(conn, :create, @account_id),
          transfer: %{
            amount: 1000,
            destination_account_id: "test_acc_12g312uhak",
            idempotency_key: random_idempotency_key(),
            reference: "test"
          }
        )

      assert json_response(conn, 200)
    end

    test "return status code 409 with used idempotency key and a duplicate transfer", %{
      conn: conn
    } do
      idempotency_key = random_idempotency_key()

      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> post(Routes.transfer_path(conn, :create, @account_id),
          transfer: %{
            amount: 1000,
            destination_account_id: "test_acc_12g312uhak",
            idempotency_key: idempotency_key,
            reference: "test"
          }
        )

      assert json_response(conn, 200)

      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> post(Routes.transfer_path(conn, :create, @account_id),
          transfer: %{
            amount: 500,
            destination_account_id: "test_acc_12g312uhak",
            idempotency_key: idempotency_key,
            reference: "test"
          }
        )

      assert json_response(conn, 409)

      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("#{@api_token}:"))
        |> post(Routes.transfer_path(conn, :create, @account_id),
          transfer: %{
            amount: 1000,
            destination_account_id: "test_acc_12g312uhak",
            idempotency_key: idempotency_key,
            reference: "test"
          }
        )

      assert json_response(conn, 200)
    end
  end
end
