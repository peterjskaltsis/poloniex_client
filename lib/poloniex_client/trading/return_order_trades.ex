defmodule PoloniexClient.Trading.ReturnOrderTrades do
  @moduledoc false

  alias PoloniexClient.Api
  alias PoloniexClient.InvalidOrderNumberError

  # Poloniex Command Name
  @return_order_trades "returnOrderTrades"

  @doc false
  def return_order_trades(order_number) do
    @return_order_trades
    |> Api.trading(orderNumber: order_number)
    |> parse_response
  end

  defp parse_response({:ok, trades}) do
    {:ok, trades}
  end

  defp parse_response({:error, "Invalid orderNumber parameter." = reason}) do
    {:error, %InvalidOrderNumberError{message: reason}}
  end

  defp parse_response(
         {:error, "Order not found, or you are not the person who placed it." = reason}
       ) do
    {:error, %InvalidOrderNumberError{message: reason}}
  end

  defp parse_response({:error, response}) do
    {:error, response}
  end
end
