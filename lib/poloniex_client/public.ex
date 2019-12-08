defmodule PoloniexClient.Public do
  @moduledoc """
  Module for Poloniex Public API Commands/Methods
  https://poloniex.com/support/api/
  """

  alias PoloniexClient.Api

  # Poloniex Command Definitions

  @return_ticker "returnTicker"
  @return_24h_volume "return24hVolume"
  @return_order_book "returnOrderBook"
  @return_trade_history "returnTradeHistory"
  @return_chart_data "returnChartData"
  @return_currencies "returnCurrencies"
  @return_loan_orders "returnLoanOrders"

  # Client Commands

  @doc """
  Retrieves summary information for each currency pair listed on the exchange.
  """
  def return_ticker do
    case Api.public(@return_ticker) do
      {:ok, balances} -> {:ok, balances}
      errors -> errors
    end
  end

  @doc """
  Returns the 24-hour volume for all markets as well as totals for primary currencies.
  Primary currencies include BTC, ETH, USDT, USDC and show the total amount of those 
  tokens that have traded within the last 24 hours.
  """
  def return_24h_volume do
    case Api.public(@return_24h_volume) do
      {:ok, volume} -> {:ok, volume}
      errors -> errors
    end
  end

  @doc """
  Returns the order book for a given market, 
  as well as a sequence number used by websockets for synchronization of book updates 
  and an indicator specifying whether the market is frozen. 

  You may set currencyPair to "all" to get the order books of all markets.
  """
  def return_order_book(currency_pair, depth \\ nil) do
    case Api.public(@return_order_book, currencyPair: currency_pair, depth: depth) do
      {:ok, order_book} -> {:ok, order_book}
      errors -> errors
    end
  end

  @doc """
  Returns the past 200 trades for a given market, or up to 1,000 trades between a specified time range.
  Uses UNIX timestamps by the "start" and "end" parameters. 
  """
  def return_trade_history(currencyPair, start_time, end_time) do
    case Api.public(@return_trade_history,
           currencyPair: currencyPair,
           start: start_time,
           end: end_time
         ) do
      {:ok, trade_history} -> {:ok, trade_history}
      errors -> errors
    end
  end

  @doc """
  Returns candlestick chart data. 
  Required parameters: "currencyPair", "start", "end" and "period" 
  (candlestick period in secs; valid values: 300, 900, 1800, 7200, 14400, and 86400). 

  "start" and "end" are UNIX timestamps, used to specify the date range for the data returned.
  """
  def return_chart_data(currency_pair, start_time, end_time, period) do
    case Api.public(@return_chart_data,
           currencyPair: currency_pair,
           start: start_time,
           end: end_time,
           period: period
         ) do
      {:ok, chart_data} -> {:ok, chart_data}
      errors -> errors
    end
  end

  @doc """
  Returns information about currencies. 
  """
  def return_currencies do
    case Api.public(@return_currencies) do
      {:ok, currencies} -> {:ok, currencies}
      errors -> errors
    end
  end

  @doc """
  Returns the list of loan offers and demands for a given currency, 
  specified by the "currency" parameter.
  """
  def return_loan_orders(currency) do
    case Api.public(@return_loan_orders, %{currency: currency}) do
      {:ok, loan_orders} -> {:ok, loan_orders}
      errors -> errors
    end
  end
end
