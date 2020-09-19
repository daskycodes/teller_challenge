defmodule TellerChallengeWeb.AccountController do
  use TellerChallengeWeb, :controller

  alias TellerChallenge.Banking
  alias TellerChallengeWeb.Authorizer

  action_fallback TellerChallengeWeb.FallbackControler

  def index(conn, _params) do
    {api_token, _pass} = Plug.BasicAuth.parse_basic_auth(conn)
    accounts = Banking.list_accounts(api_token)

    render(conn, "index.json", accounts: accounts)
  end

  def show(conn, %{"account_id" => account_id}) do
    {api_token, _pass} = Plug.BasicAuth.parse_basic_auth(conn)

    with {:ok, account} <- Banking.fetch_account(account_id),
         :ok <- Authorizer.authorize(api_token, :view, account_id) do
      render(conn, "show.json", account: account)
    end
  end
end
