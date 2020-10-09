defmodule TellerChallengeWeb.TransferController do
  use TellerChallengeWeb, :controller

  alias TellerChallenge.Banking.Transfer

  def create(
        conn,
        %{
          "amount" => amount,
          "account_id" => source_account_id,
          "destination_account_id" => destination_account_id,
          "reference" => reference,
          "idempotency_key" => idempotency_key
        } = params
      ) do
    with {:ok, %Transfer{} = transfer} <-
           TellerChallenge.Banking.create_transfer(
             amount,
             source_account_id,
             destination_account_id,
             reference,
             idempotency_key
           ) do
      json(conn, "OK")
    else
      {:error, :conflict} ->
        render(conn, "error.json", message: "Idempotency Key was already used")
    end
  end
end
