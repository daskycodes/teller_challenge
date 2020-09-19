defmodule TellerChallengeWeb.TransactionView do
  use TellerChallengeWeb, :view

  alias TellerChallengeWeb.Router.Helpers, as: Routes
  alias TellerChallengeWeb.Endpoint
  alias TellerChallengeWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    render_many(transactions, TransactionView, "transaction.json")
  end

  def render("show.json", %{transaction: transaction}) do
    render_one(transaction, TransactionView, "transaction.json")
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      type: transaction.type,
      running_balance: integer_to_currency(transaction.running_balance),
      links: %{
        account: Routes.account_url(Endpoint, :show, transaction.account_id),
        self: Routes.transaction_url(Endpoint, :show, transaction.account_id, transaction.id)
      },
      id: transaction.id,
      description: transaction.description,
      date: transaction.date,
      amount: integer_to_currency(transaction.amount),
      account_id: transaction.account_id
    }
  end
end
