defmodule TellerChallengeWeb.AccountView do
  use TellerChallengeWeb, :view

  alias TellerChallengeWeb.Router.Helpers, as: Routes
  alias TellerChallengeWeb.Endpoint
  alias TellerChallengeWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    render_many(accounts, AccountView, "account.json")
  end

  def render("show.json", %{account: account}) do
    render_one(account, AccountView, "account.json")
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      type: account.type,
      subtype: account.subtype,
      routing_numbers: %{ach: to_string(account.routing_numbers.ach)},
      name: account.name,
      institution: account.institution,
      enrollment_id: account.enrollment_id,
      currency_code: account.currency_code,
      balances: %{
        ledger: integer_to_currency(account.balances.ledger),
        available: integer_to_currency(account.balances.available)
      },
      account_number: to_string(account.account_number),
      links: %{
        self: Routes.account_url(Endpoint, :show, account.id),
        transactions: Routes.transaction_url(Endpoint, :index, account.id)
      }
    }
  end
end
