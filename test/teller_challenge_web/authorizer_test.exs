defmodule TellerChallengeWeb.AuthorizerTest do
  use ExUnit.Case, async: true
  import TestHelper

  alias TellerChallengeWeb.Authorizer

  @authorized_api_token random_api_token()
  @account_id account_id_from_api_token(@authorized_api_token)
  @unauthorized_api_token random_api_token()

  test "authorize/2 returns :ok when user is authorized to view the account" do
    assert :ok = Authorizer.authorize(@authorized_api_token, :view, @account_id)
  end

  test "authorize/2 returns {:error, message} when user is not authorized to view the account" do
    assert {:error, message} = Authorizer.authorize(@unauthorized_api_token, :view, @account_id)
  end
end
