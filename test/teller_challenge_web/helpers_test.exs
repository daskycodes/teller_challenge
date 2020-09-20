defmodule TellerChallengeWeb.HelpersTest do
  use ExUnit.Case, async: true

  import TellerChallengeWeb.Helpers

  describe "currency conversion" do
    @cents 5000

    test "integer_to_currency/1 returns decimal" do
      assert integer_to_currency(@cents) == Decimal.new("50.00")
    end
  end

  describe "pagination" do
    @list for id <- 1..10, do: %{id: "#{id}"}
    @count 5
    @id "5"

    test "paginate/3 returns count items when id is an empty string" do
      assert Enum.count(paginate(@list, @count, "")) == 5
    end

    test "paginate/3 returns count items starting from id" do
      list = paginate(@list, @count, @id)

      assert Enum.count(list) == 5
      assert List.first(list) == %{id: "4"}
    end

    test "paginate/3 returns full list when count is 0 and id is an empty string" do
      assert Enum.count(paginate(@list, 0, "")) == 10
    end
  end
end
