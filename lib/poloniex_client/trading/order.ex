defmodule PoloniexClient.Trading.Order do
  @moduledoc false

  alias PoloniexClient.{
    FillOrKillError,
    NotEnoughError,
    PostOnlyError
  }

  alias PoloniexClient.Trading.{OrderResponse, Trade}

  alias PoloniexClient.Trading.{
    FillOrKill,
    ImmediateOrCancel,
    PostOnly,
    TakeAndRemain
  }

  @doc false
  def build_params(pair, rate, amount, order_type) do
    (order_type || %TakeAndRemain{})
    |> List.wrap()
    |> Enum.reduce(
      [currencyPair: pair, rate: rate, amount: amount],
      &add_order_type_param/2
    )
  end

  @doc false
  def parse_response(
        {:ok, %{"orderNumber" => order_number, "resultingTrades" => raw_trades} = raw_response}
      ) do
    {:ok,
     %OrderResponse{
       order_number: order_number,
       resulting_trades: raw_trades |> Enum.map(&Trade.parse!/1),
       amount_unfilled: raw_response |> parse_amount_unfilled
     }}
  end

  @doc false
  def parse_response({:error, "Not enough " <> _ = reason}) do
    {:error, %NotEnoughError{message: reason}}
  end

  @doc false
  def parse_response({:error, "Unable to fill order completely." = reason}) do
    {:error, %FillOrKillError{message: reason}}
  end

  @doc false
  def parse_response({:error, "Unable to place post-only order at this price." = reason}) do
    {:error, %PostOnlyError{message: reason}}
  end

  @doc false
  def parse_response({:error, _} = error), do: error

  defp parse_amount_unfilled(raw_response) do
    raw_response
    |> Map.get("amountUnfilled")
    |> case do
      nil ->
        nil

      raw_amount ->
        {amount, ""} = Float.parse(raw_amount)
        amount
    end
  end

  defp add_order_type_param(%FillOrKill{}, acc), do: Keyword.put(acc, :fillOrKill, 1)

  defp add_order_type_param(%ImmediateOrCancel{}, acc) do
    Keyword.put(acc, :immediateOrCancel, 1)
  end

  defp add_order_type_param(%PostOnly{}, acc), do: Keyword.put(acc, :postOnly, 1)
  defp add_order_type_param(%TakeAndRemain{}, acc), do: acc
end
