defmodule TellerChallenge.Banking.Generator do
  import TellerChallenge.Helpers
  import TellerChallenge.Banking.Fixtures

  alias TellerChallenge.Banking.{Account, Transaction}

  @max_balance_in_cents 250_000
  @max_amount_in_cents 2500
  @day_in_seconds 86400
  @hour_in_seconds 3600

  def accounts(api_token, max_accounts \\ 5) do
    {seed, _rest} = api_token |> Base.url_encode64() |> Integer.parse(36)
    :random.seed(seed)
    amount_of_accounts = :random.uniform(max_accounts)

    for n <- 1..amount_of_accounts do
      # account_id = "test_acc_" <> hash_from_api_token(api_token) <> "#{n}"
      account_id = "test_acc_" <> account_hash(api_token, n)
      account(account_id)
    end
  end

  def account(account_id) do
    {seed, _rest} = account_id |> Base.url_encode64() |> Integer.parse(36)
    :random.seed(seed)

    # case check if transfers exists
    # merge transfers with account

    %Account{
      balances: generate_balances(),
      id: account_id,
      type: "depository",
      subtype: "checking",
      routing_numbers: %{ach: :random.uniform(999_999_999)},
      name: Enum.fetch!(account_names(), :random.uniform(Enum.count(account_names())) - 1),
      institution: generate_institution(),
      enrollment_id: "test_enr_" <> Base.url_encode64("#{:random.uniform(999_999_999)}"),
      currency_code: "USD",
      account_number: :random.uniform(999_999_999)
    }
  end

  def transactions(account_id, max_days) do
    timestamp = timestamp_from_account_id(account_id)
    {seed, _rest} = account_id |> Base.url_encode64() |> Integer.parse(36)

    # case check if transfers exists
    # merge transfers with transactions

    :random.seed(seed)

    balance = generate_balances().ledger
    date = DateTime.from_unix!(timestamp)

    generate_transactions(account_id, date, balance, max_days, [])
  end

  def transaction(account_id, date, balance, amount) do
    %Transaction{
      type: "card_payment",
      running_balance: balance,
      id: "test_txn_" <> Base.url_encode64("#{:random.uniform(999_999_999)}"),
      description: Enum.fetch!(merchants(), :random.uniform(Enum.count(merchants())) - 1),
      date: date,
      amount: amount,
      account_id: account_id
    }
  end

  defp generate_transactions(_account_id, _date, _balance, days, transactions) when days < 0 do
    transactions
  end

  defp generate_transactions(account_id, date, balance, days, transactions) do
    daily_transactions =
      generate_daily_transactions(account_id, date, balance, :random.uniform(5) - 1, [])

    amount =
      case length(daily_transactions) do
        0 -> 0
        _ -> Enum.map(daily_transactions, & &1.amount) |> Enum.sum()
      end

    generate_transactions(
      account_id,
      DateTime.add(date, -@day_in_seconds),
      balance - amount,
      days - 1,
      transactions ++ daily_transactions
    )
  end

  defp generate_daily_transactions(
         _account_id,
         _date,
         _balance,
         amount_of_transactions,
         transactions
       )
       when amount_of_transactions < 1 do
    transactions
  end

  defp generate_daily_transactions(
         account_id,
         date,
         balance,
         amount_of_transactions,
         transactions
       ) do
    amount = :random.uniform(@max_amount_in_cents) * -1
    transaction = transaction(account_id, date, balance, amount)

    generate_daily_transactions(
      account_id,
      DateTime.add(date, -@hour_in_seconds),
      balance - amount,
      amount_of_transactions - 1,
      transactions ++ [transaction]
    )
  end

  defp generate_balances() do
    balance = :random.uniform(@max_balance_in_cents)
    %{ledger: balance, available: balance}
  end

  defp generate_institution() do
    institution_name =
      Enum.fetch!(institutions(), :random.uniform(Enum.count(institutions())) - 1)

    institution_id = institution_name |> String.replace(" ", "_") |> String.downcase()

    %{name: institution_name, id: institution_id, capabilities: ["transaction"]}
  end
end
