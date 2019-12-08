defmodule PoloniexClient.Trading.HistoricalTrade do
  @moduledoc false

  @enforce_keys [
    :amount,
    :category,
    :date,
    :fee,
    :global_trade_id,
    :order_number,
    :rate,
    :total,
    :trade_id,
    :type
  ]
  defstruct [
    :amount,
    :category,
    :date,
    :fee,
    :global_trade_id,
    :order_number,
    :rate,
    :total,
    :trade_id,
    :type
  ]
end
