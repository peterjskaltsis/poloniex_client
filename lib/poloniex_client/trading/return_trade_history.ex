defmodule PoloniexClient.Trading.ReturnTradeHistory do
  @moduledoc false

  alias PoloniexClient.Api
  alias PoloniexClient.Trading.HistoricalTrade

  # Poloniex Command Name
  @return_trade_history "returnTradeHistory"

  @doc false
  def return_trade_history(currency_pair, %DateTime{} = start, %DateTime{} = to) do
    start_unix = DateTime.to_unix(start)
    end_unix = DateTime.to_unix(to)

    @return_trade_history
    |> Api.trading(currencyPair: currency_pair, start: start_unix, end: end_unix)
    |> parse_response
  end

  defp parse_response({:ok, raw_historical_trades}) do
    historical_trades =
      raw_historical_trades
      |> Enum.map(&parse_historical_trade/1)

    {:ok, historical_trades}
  end

  defp parse_response({:error, reason}) do
    {:error, reason}
  end

  defp parse_historical_trade(%{
         "amount" => raw_amount,
         "category" => category,
         "date" => raw_date,
         "fee" => raw_fee,
         "globalTradeID" => global_trade_id,
         "orderNumber" => order_number,
         "rate" => raw_rate,
         "total" => raw_total,
         "tradeID" => trade_id,
         "type" => type
       }) do
    with {amount, ""} <- Float.parse(raw_amount),
         {:ok, date_without_zone} <- Timex.parse(raw_date, "{ISO:Extended}"),
         {:ok, date} <- DateTime.from_naive(date_without_zone, "Etc/UTC"),
         {fee, ""} <- Float.parse(raw_fee),
         {rate, ""} <- Float.parse(raw_rate),
         {total, ""} <- Float.parse(raw_total) do
      %HistoricalTrade{
        amount: amount,
        category: category,
        date: date,
        fee: fee,
        global_trade_id: global_trade_id,
        order_number: order_number,
        rate: rate,
        total: total,
        trade_id: trade_id,
        type: type
      }
    end
  end
end
