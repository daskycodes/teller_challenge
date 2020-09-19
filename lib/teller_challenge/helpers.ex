defmodule TellerChallenge.Helpers do
  def take_prefix(full, prefix) do
    base = byte_size(prefix)
    <<_::binary-size(base), rest::binary>> = full
    rest
  end

  def hash_from_api_token(api_token) do
    api_token
    |> take_prefix("test_")
    |> String.slice(0..9)
    |> String.replace_suffix("", "0")
    |> Base.url_encode64()
  end

  def account_hash(api_token, n) do
    api_token
    |> take_prefix("test_")
    |> String.slice(0..9)
    |> String.replace_suffix("", "0#{n}")
    |> Base.url_encode64()
  end

  def hash_from_account_id(account_id) do
    take_prefix(account_id, "test_acc_")
    |> String.slice(0..14)
    |> String.replace_suffix("", "=")
  end

  def timestamp_from_account_id(account_id) do
    hash_from_account_id(account_id)
    |> Base.decode64!()
    |> String.slice(4..9)
    |> String.to_integer(36)
  end
end
