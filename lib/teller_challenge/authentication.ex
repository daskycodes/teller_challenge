defmodule TellerChallenge.Authentication do
  alias TellerChallenge.Authentication.User

  @repo TellerChallenge.FakeRepo

  def find_by_api_token(api_token, pass) when pass == "" do
    with true <- valid_api_token?(api_token) do
      @repo.get_by(User, api_token: api_token)
    else
      _ -> {:error, "Invalid api token"}
    end
  end

  def find_by_api_token(_api_token, _pass), do: {:error, "Password needs to be empty"}

  defp valid_api_token?(api_token) do
    String.starts_with?(api_token, "test_") &&
      String.length(api_token) > 14 &&
      String.match?(api_token, ~r/^[a-zA-Z0-9_=-]*$/)
  end
end
