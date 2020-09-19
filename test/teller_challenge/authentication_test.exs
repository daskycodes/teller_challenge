defmodule TellerChallenge.AuthenticationTest do
  use ExUnit.Case, async: true

  alias TellerChallenge.Authentication
  alias TellerChallenge.Authentication.User

  @valid_api_token "test_0123456789"
  @invalid_api_token "test_012345678"

  describe "users" do
    test "find_by_api_token/2 returns valid user struct when valid api_token is given and pass is an empty string" do
      assert %User{} = Authentication.find_by_api_token(@valid_api_token, "")
    end

    test "find_by_api_token/2 returns false when api_token is not valid" do
      assert {:error, message} = Authentication.find_by_api_token(@invalid_api_token, "")
    end

    test "find_by_api_token/2 returns error when pass is not empty" do
      assert {:error, message} = Authentication.find_by_api_token(@valid_api_token, "pass")
    end
  end
end
