defmodule TellerChallenge.Banking do
  alias TellerChallenge.Banking.{Account, Transaction, Transfer}
  alias TellerChallenge.IdempotencyKeyStore

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

  def create_transfer(amount, source_account_id, destination_account_id, reference, idempotency_key) do
    source_account = fetch_account(source_account_id)
    destination_account = fetch_account(destination_account_id)

    transfer = %Transfer{id: TellerChallenge.Helpers.random_id(), amount: amount, source_account_id: source_account_id, destination_account_id: destination_account_id, date: Date.utc_today(), reference: reference, idempotency_key: idempotency_key}
    with {:ok, transfer} <- IdempotencyKeyStore.check_if_idempotency_key_is_unused(transfer) do
      transfer_money()
      {:ok, transfer}
    else
      {:exists, _something} -> {:error, :conflict}
    end
  end
end
