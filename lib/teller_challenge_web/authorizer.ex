defmodule TellerChallengeWeb.Authorizer do
  import TellerChallenge.Helpers

  def authorize(api_token, :view, account_id),
    do: if(is_authorized?(api_token, account_id), do: :ok, else: {:error, :unauthorized})

  defp is_authorized?(api_token, account_id),
    do:
      Plug.Crypto.secure_compare(
        hash_from_account_id(account_id),
        hash_from_api_token(api_token)
      )
end
