defmodule PoloniexClient.Trading.MoveOrder do
  @moduledoc false

  import PoloniexClient.Trading.Order
  alias PoloniexClient.Api

  alias PoloniexClient.Trading.{
    ImmediateOrCancel,
    PostOnly
  }

  # Poloniex Command Name
  @move_order "moveOrder"

  @doc false
  def move_order(order_number, rate, client_order_id, order_type, amount) do
    params = build_order_params(order_number, rate, client_order_id, order_type, amount)

    @move_order
    |> Api.trading(params)
    |> parse_response
  end

  @doc false
  def build_order_params(order_number, rate, client_order_id, order_type, amount) do
    order_type
    |> List.wrap()
    |> Enum.reduce(
      [
        orderNumber: order_number,
        rate: rate,
        clientOrderId: client_order_id,
        orderType: order_type,
        amount: amount
      ],
      &add_order_type_param/2
    )
    |> Enum.filter(fn {_, val} -> val != nil end)
    |> IO.inspect()
  end

  defp add_order_type_param(%ImmediateOrCancel{}, acc),
    do: Keyword.put(acc, :immediateOrCancel, 1)

  defp add_order_type_param(%PostOnly{}, acc),
    do: Keyword.put(acc, :postOnly, 1)
end
