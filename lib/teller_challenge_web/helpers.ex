defmodule TellerChallengeWeb.Helpers do
  def integer_to_currency(cents) do
    cents
    |> Decimal.div(100)
    |> Decimal.round(2)
  end

  def paginate(list, count, id) when (count > 0 and id == "") or (count > 0 and is_nil(id)),
    do: Enum.take(list, count)

  def paginate(list, count, id) when count > 0 do
    list
    |> Enum.drop_while(&(&1.id != id))
    |> Enum.drop(1)
    |> Enum.take(count)
  end

  def paginate(list, _count, _id), do: list

  def generate_api_token() do
    prefix = "test_"
    random_hash = Enum.random(46656..1_679_615) |> Integer.to_string(36)
    timestamp_hash = :os.system_time(:seconds) |> Integer.to_string(36)
    prefix <> random_hash <> timestamp_hash
  end
end
