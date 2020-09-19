defmodule TellerChallenge.BankingTest do
  use ExUnit.Case, async: true
  import TestHelper

  alias TellerChallenge.Banking.Generator
  alias TellerChallenge.Banking

  @api_token random_api_token()
  @account_id account_id_from_api_token(@api_token)

  describe "accounts" do
    test "list_accounts/1 lists all accounts by the given api_token" do
      assert Banking.list_accounts(@api_token) == Generator.accounts(@api_token)
    end

    test "fetch_account/1 returns the account with the given id" do
      {:ok, account} = Banking.fetch_account(@account_id)
      assert account == Generator.account(@account_id)
    end
  end

  describe "transactions" do
    setup do
      [transactions: Generator.transactions(@account_id, 90)]
    end

    test "list_transactions/1 lists all transactions by the given account_id", context do
      assert Banking.list_transactions(@account_id) == context[:transactions]
    end

    test "fetch_transactions/2 returns the transaction with the given transaction_id and account_id",
         context do
      transaction_id = List.first(context[:transactions]).id
      {:ok, transaction} = Banking.fetch_transaction(transaction_id, @account_id)

      assert transaction == List.first(context[:transactions])
    end
  end
end
