defmodule PoloniexClient.Trading.OrderResponse do
  @moduledoc false

  @enforce_keys [:order_number, :resulting_trades]
  defstruct [:order_number, :resulting_trades, :amount_unfilled]
end
