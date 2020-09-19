defmodule TellerChallenge.Banking do
  alias TellerChallenge.Banking.{Account, Transaction}

  @repo TellerChallenge.FakeRepo

  def list_accounts(api_token) do
    @repo.get_by(Account, api_token: api_token)
  end

  def fetch_account(account_id) do
    case @repo.get(Account, account_id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  def list_transactions(account_id) do
    @repo.get_by(Transaction, account_id: account_id)
  end

  def fetch_transaction(transaction_id, account_id) do
    case @repo.get_by(Transaction, transaction_id: transaction_id, account_id: account_id) do
      nil -> {:error, :not_found}
      transaction -> {:ok, transaction}
    end
  end
end
