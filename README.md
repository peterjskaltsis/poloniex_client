# Poloniex Client

Poloniex Public/Trade API Elixir Client

## Progress

**Public API implemented**

- [x] returnTicker
- [x] return24hVolume
- [x] returnOrderBook
- [x] returnTradeHistory (public)
- [x] returnChartData
- [x] returnCurrencies
- [x] returnLoanOrders


**Trading API in progress**

- [x] returnBalances
- [x] returnCompleteBalances
- [x] returnDepositAddresses
- [x] generateNewAddress
- [x] returnDepositsWithdrawals
- [x] returnOpenOrders
- [x] returnTradeHistory (private)
- [x] returnOrderTrades
- [x] returnOrderStatus
- [x] buy
- [x] sell
- [x] cancelOrder
- [x] cancelAllOrders
- [x] moveOrder
- [x] withdraw
- [x] returnFeeInfo
- [x] returnAvailableAccountBalances
- [x] returnTradableBalances
- [x] transferBalance
- [x] returnMarginAccountSummary
- [x] marginBuy
- [x] marginSell
- [x] getMarginPosition
- [x] closeMarginPosition
- [x] createLoanOffer
- [x] cancelLoanOffer
- [x] returnOpenLoanOffers
- [x] returnActiveLoans
- [x] returnLendingHistory
- [x] toggleAutoRenew

## Installation

This package can be installed by adding `poloniex_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:poloniex_client, "~> 0.0.1"}
  ]
end
```

## Configuration

Add the following configuration variables in your `config/config.exs` file:

```elixir
use Mix.Config

config :poloniex_client,
  api_key: "YOUR_API_KEY",
  api_secret: "YOUR_API_SECRET"
```

## Additional Links

[Poloniex API Docs](https://poloniex.com/support/api/)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/poloniex_client](https://hexdocs.pm/poloniex_client).

