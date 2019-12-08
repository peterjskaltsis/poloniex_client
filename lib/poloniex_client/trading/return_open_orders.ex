defmodule PoloniexClient.Trading.ReturnOpenOrders do
  @moduledoc false

  alias PoloniexClient.Api
  alias PoloniexClient.Trading.OpenOrder

  # Poloniex Command Name
  @return_open_orders "returnOpenOrders"

  @doc false
  def return_open_orders(currency_pair) do
    @return_open_orders
    |> Api.trading(currencyPair: currency_pair)
    |> parse_response
  end

  defp parse_response({:ok, raw_open_orders}) when is_map(raw_open_orders) do
    open_orders =
      raw_open_orders
      |> Enum.reduce(%{}, &deserialize_currency_pair_open_orders/2)

    {:ok, open_orders}
  end

  defp parse_response({:ok, raw_open_orders}) when is_list(raw_open_orders) do
    open_orders =
      raw_open_orders
      |> Enum.map(&deserialize_open_order/1)

    {:ok, open_orders}
  end

  defp parse_response({:error, _} = error) do
    error
  end

  defp deserialize_currency_pair_open_orders({currency_pair, raw_open_orders}, acc) do
    open_orders =
      raw_open_orders
      |> Enum.map(&deserialize_open_order/1)

    acc
    |> Map.put(currency_pair, open_orders)
  end

  defp deserialize_open_order(%{
         "amount" => raw_amount,
         "date" => raw_date,
         "margin" => margin,
         "orderNumber" => order_number,
         "rate" => raw_rate,
         "startingAmount" => raw_starting_amount,
         "total" => raw_total,
         "type" => type
       }) do
    with {amount, ""} <- Float.parse(raw_amount),
         {rate, ""} <- Float.parse(raw_rate),
         {starting_amount, ""} <- Float.parse(raw_starting_amount),
         {total, ""} <- Float.parse(raw_total),
         {:ok, date_without_zone} <- Timex.parse(raw_date, "{ISO:Extended}"),
         {:ok, date} <- DateTime.from_naive(date_without_zone, "Etc/UTC") do
      %OpenOrder{
        amount: amount,
        date: date,
        margin: margin,
        order_number: order_number,
        rate: rate,
        starting_amount: starting_amount,
        total: total,
        type: type
      }
    end
  end
end
