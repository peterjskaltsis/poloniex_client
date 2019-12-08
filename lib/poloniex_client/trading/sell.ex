defmodule PoloniexClient.Trading.Sell do
  @moduledoc false

  import PoloniexClient.Trading.Order
  alias PoloniexClient.Api

  # Poloniex Command Name
  @sell "sell"

  @doc false
  def sell(pair, rate, amount, order_type) do
    params = build_params(pair, rate, amount, order_type)

    @sell
    |> Api.trading(params)
    |> parse_response
  end
end
