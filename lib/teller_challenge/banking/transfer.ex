defmodule TellerChallenge.Banking.Transfer do
  defstruct [
    :id,
    :amount,
    :source_account_id,
    :destination_account_id,
    :date,
    :reference,
    :idempotency_key,
    :confirmation_code
  ]
end
