defmodule TellerChallenge.Banking.Transaction do
  defstruct [
    :id,
    :type,
    :running_balance,
    :description,
    :date,
    :amount,
    :account_id
  ]
end
