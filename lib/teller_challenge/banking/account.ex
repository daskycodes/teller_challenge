defmodule TellerChallenge.Banking.Account do
  defstruct [
    :id,
    :type,
    :subtype,
    :routing_numbers,
    :name,
    :institution,
    :enrollment_id,
    :currency_code,
    :balances,
    :account_number,
    :user_hash
  ]
end
