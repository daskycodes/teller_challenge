defmodule TellerChallengeWeb.TransactionController do
  use TellerChallengeWeb, :controller

  alias TellerChallenge.Banking

  alias TellerChallengeWeb.Authorizer

  action_fallback TellerChallengeWeb.FallbackControler

  @optional_params %{"count" => "0", "from_id" => ""}

  def index(conn, %{"account_id" => account_id} = params) do
    {api_token, _pass} = Plug.BasicAuth.parse_basic_auth(conn)

    params = Map.merge(@optional_params, params)
    count = Map.get(params, "count") |> String.to_integer()
    txn_id = Map.get(params, "from_id")

    transactions =
      Banking.list_transactions(account_id)
      |> paginate(count, txn_id)

    with :ok <- Authorizer.authorize(api_token, :view, account_id),
         do: render(conn, "index.json", transactions: transactions)
  end

  def show(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    {api_token, _pass} = Plug.BasicAuth.parse_basic_auth(conn)

    with {:ok, transaction} <- Banking.fetch_transaction(transaction_id, account_id),
         :ok <- Authorizer.authorize(api_token, :view, account_id) do
      render(conn, "show.json", transaction: transaction)
    end
  end
end
