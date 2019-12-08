defmodule PoloniexClient.Trading.Trade do
  @moduledoc false

  @enforce_keys [:amount, :date, :rate, :total, :trade_id, :type]
  defstruct [:amount, :date, :rate, :total, :trade_id, :type]

  @doc false
  def parse!(%{
        "amount" => raw_amount,
        "date" => raw_date,
        "rate" => raw_rate,
        "total" => raw_total,
        "tradeID" => trade_id,
        "type" => type
      }) do
    with {amount, ""} <- Float.parse(raw_amount),
         {:ok, date_without_zone} <- Timex.parse(raw_date, "{ISO:Extended}"),
         {:ok, date} <- DateTime.from_naive(date_without_zone, "Etc/UTC"),
         {rate, ""} <- Float.parse(raw_rate),
         {total, ""} <- Float.parse(raw_total) do
      %__MODULE__{
        amount: amount,
        date: date,
        rate: rate,
        total: total,
        trade_id: trade_id,
        type: type
      }
    end
  end
end
