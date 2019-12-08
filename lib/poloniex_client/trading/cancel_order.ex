defmodule PoloniexClient.Trading.CancelOrder do
  @moduledoc false

  alias PoloniexClient.Api
  alias PoloniexClient.InvalidOrderNumberError

  # Poloniex Command Name
  @cancel_order "cancelOrder"

  @doc false
  def cancel_order(order_number) do
    case Api.trading(@cancel_order, orderNumber: order_number) do
      {:ok, %{"success" => 1, "amount" => amount_str}} ->
        {amount, ""} = Float.parse(amount_str)
        {:ok, amount}

      {:error, "Invalid order number" <> _ = reason} ->
        {:error, %InvalidOrderNumberError{message: reason}}

      {:error, "Invalid orderNumber parameter" <> _ = reason} ->
        {:error, %InvalidOrderNumberError{message: reason}}

      {:error, _} = error ->
        error
    end
  end
end
