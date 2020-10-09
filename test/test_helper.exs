ExUnit.start()

defmodule TestHelper do
  import TellerChallenge.Helpers

  def random_api_token() do
    Enum.random(1000_00000..20000_0000)
    |> Integer.to_string()
    |> Base.url_encode64()
    |> String.replace_prefix("", "test_")
  end

  def random_idempotency_key() do
    Enum.random(1000_00000..20000_0000)
    |> Integer.to_string()
    |> Base.url_encode64()
  end

  def account_id_from_api_token(api_token) do
    account_hash(api_token, 1)
    |> String.replace_prefix("", "test_acc_")
  end

  def transaction_id_from_account_id(account_id),
    do: List.first(TellerChallenge.Banking.Generator.transactions(account_id, 90)).id
end
