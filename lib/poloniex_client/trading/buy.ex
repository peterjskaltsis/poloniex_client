defmodule PoloniexClient.Trading.Buy do
  @moduledoc false

  import PoloniexClient.Trading.Order
  alias PoloniexClient.Api

  # Poloniex Command Name
  @buy "buy"

  @doc false
  def buy(pair, rate, amount, order_type) do
    params = build_params(pair, rate, amount, order_type)

    @buy
    |> Api.trading(params)
    |> parse_response
  end
end
