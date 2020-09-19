defmodule TellerChallenge.Banking.GeneratorTest do
  use ExUnit.Case, async: true
  import TestHelper

  alias TellerChallenge.Banking.{Generator, Account, Transaction}

  @api_token random_api_token()
  @account_id account_id_from_api_token(@api_token)

  setup_all do
    [
      accounts: Generator.accounts(@api_token, 5),
      transactions: Generator.transactions(@account_id, 90)
    ]
  end

  describe "generate accounts" do
    test "accounts/2 returns a list of %Account{} structs", context do
      accounts = context[:accounts]

      assert is_list(accounts)
      assert %Account{} = List.first(accounts)
    end

    test "accounts/2 returns same list of %Account{} structs each time", context do
      accounts = context[:accounts]

      assert Generator.accounts(@api_token, 5) === accounts
      refute Generator.accounts("test_0123456789", 5) === accounts
    end

    test "account/1 returns a single %Account{} struct" do
      account = Generator.account(@account_id)

      assert %Account{} = account
    end

    test "account's institution id should be the snake cased institution name" do
      account = Generator.account(@account_id)

      snake_cased_name =
        account.institution.name
        |> String.replace(" ", "_")
        |> String.downcase()

      assert account.institution.id == snake_cased_name
    end
  end

  describe "generate transactions" do
    test "transactions/2 returns a list of %Transaction{} structs" do
      transactions = Generator.transactions(@account_id, 90)

      assert is_list(transactions)
      assert %Transaction{} = List.first(transactions)
    end

    test "transactions/2 returns same list of %Transaction{} structs each time" do
      transactions = Generator.transactions(@account_id, 90)

      assert Generator.transactions(@account_id, 90) === transactions
    end

    test "transactions should contain transactions for 90 days" do
      transactions = Generator.transactions(@account_id, 90)

      # Allow Delta since some days can have 0 transactions
      assert_in_delta(
        Date.diff(List.first(transactions).date, List.last(transactions).date),
        90,
        5
      )
    end

    test "transactions absolute total amount of transactions should equal the balance difference minus the last transactions amount" do
      transactions = Generator.transactions(@account_id, 90)
      total_amount = Enum.map(transactions, & &1.amount) |> Enum.sum()

      balance_diff =
        List.last(transactions).running_balance - List.first(transactions).running_balance

      assert abs(total_amount) == balance_diff - List.last(transactions).amount
    end

    test "first transaction should have it's amount less balance then the second transaction's balance" do
      transactions = Generator.transactions(@account_id, 90)
      first_transaction = List.first(transactions)
      second_transaction = Enum.fetch!(transactions, 1)

      assert first_transaction.running_balance ==
               second_transaction.running_balance + first_transaction.amount
    end

    test "transaction/4 returns a single %Transaction{} struct" do
      transaction =
        Generator.transaction(@account_id, ~U[2020-09-19 12:03:27.365697Z], 5_000_000, -2500)

      assert %Transaction{} = transaction
      assert transaction.account_id == @account_id
      assert transaction.date == ~U[2020-09-19 12:03:27.365697Z]
      assert transaction.running_balance == 5_000_000
      assert transaction.amount == -2500
    end
  end
end
