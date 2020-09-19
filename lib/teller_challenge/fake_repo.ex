defmodule TellerChallenge.FakeRepo do
  import TellerChallenge.Helpers

  alias TellerChallenge.Authentication.User
  alias TellerChallenge.Banking.{Account, Transaction}

  @max_accounts 5
  @max_days 90

  def get_by(User, api_token: api_token), do: %User{hash: hash_from_api_token(api_token)}

  def get_by(User, hash: hash), do: %User{hash: hash}

  def get_by(Transaction, account_id: account_id),
    do: TellerChallenge.Banking.Generator.transactions(account_id, @max_days)

  def get_by(Transaction, transaction_id: transaction_id, account_id: account_id) do
    TellerChallenge.Banking.Generator.transactions(account_id, @max_days)
    |> Enum.filter(fn transaction -> transaction.id == transaction_id end)
    |> List.first()
  end

  def get_by(Account, api_token: api_token),
    do: TellerChallenge.Banking.Generator.accounts(api_token, @max_accounts)

  def get(Account, account_id), do: TellerChallenge.Banking.Generator.account(account_id)
end
