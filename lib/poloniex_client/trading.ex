defmodule PoloniexClient.Trading do
  @moduledoc """
  Module for Poloniex Private/Trading API Commands/Methods
  https://poloniex.com/support/api/
  """

  alias PoloniexClient.{Api, Trading}

  # Poloniex Command Definitions

  @return_balances "returnBalances"
  @return_complete_balances "returnCompleteBalances"
  @return_deposits_withdrawals "returnDepositsWithdrawals"
  @return_deposit_addresses "returnDepositAddresses"
  @generate_new_address "generateNewAddress"
  @cancel_all_orders "cancelAllOrders"
  @withdraw "withdraw"
  @return_fee_info "returnFeeInfo"
  @return_available_account_balances "returnAvailableAccountBalances"
  @return_tradable_balances "returnTradableBalances"
  @transfer_balance "transferBalance"
  @return_margin_account_summary "returnMarginAccountSummary"
  @margin_buy "marginBuy"
  @margin_sell "marginSell"
  @get_margin_position "getMarginPosition"
  @close_margin_position "closeMarginPosition"
  @create_loan_offer "createLoanOffer"
  @cancel_loan_offer "cancelLoanOffer"
  @return_open_loan_offers "returnOpenLoanOffers"
  @return_active_loans "returnActiveLoans"
  @return_lending_history "returnLendingHistory"
  @toggle_auto_renew "toggleAutoRenew"

  @doc """
  Returns all of your available balances.
  """
  def return_balances do
    case Api.trading(@return_balances) do
      {:ok, balances} -> {:ok, balances}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns all of your balances, including available balance, balance on orders, 
  and the estimated BTC value of your balance. By default, this call is limited 
  to your exchange account; set the "account" POST parameter to "all" to include 
  your margin and lending accounts.
  """
  def return_complete_balances do
    case Api.trading(@return_complete_balances) do
      {:ok, complete_balances} -> {:ok, complete_balances}
      {:error, _} = error -> error
    end
  end

  def return_complete_balances(:all) do
    case Api.trading(@return_complete_balances, account: :all) do
      {:ok, complete_balances} -> {:ok, complete_balances}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns all of your deposit addresses.
  """
  def return_deposit_addresses do
    case Api.trading(@return_deposit_addresses) do
      {:ok, deposit_addresses} -> {:ok, deposit_addresses}
      {:error, _} = error -> error
    end
  end

  @doc """
  Generates a new deposit address for the currency specified 
  by the "currency" POST parameter.
  """
  def generate_new_address(currency) do
    case Api.trading(@generate_new_address, currency: currency) do
      {:ok, %{"response" => new_address, "success" => 1}} -> {:ok, new_address}
      {:ok, %{"response" => response, "success" => 0}} -> {:error, response}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns your deposit and withdrawal history within a range, specified by the 
  "start" and "end" POST parameters, both of which should be given as UNIX timestamps.
  """
  def return_deposits_withdrawals(%DateTime{} = start, %DateTime{} = to) do
    start_unix = DateTime.to_unix(start)
    end_unix = DateTime.to_unix(to)

    case Api.trading(@return_deposits_withdrawals, start: start_unix, end: end_unix) do
      {:ok, %{"deposits" => deposits, "withdrawals" => withdrawals}} ->
        {:ok, %Trading.DepositsAndWithdrawals{deposits: deposits, withdrawals: withdrawals}}

      {:error, _} = error ->
        error
    end
  end

  # @doc """
  # Returns the market rules.
  # """
  # def return_market_rules do
  #   case Api.trading("returnMarketRules") do
  #     {:ok, rules} -> {:ok, rules}
  #     {:error, _} = error -> error
  #   end
  # end

  @doc """
  Returns your open orders for a given market, specified by the "currencyPair" 
  POST parameter, e.g. "BTC_XCP". Set "currencyPair" to "all" to return open 
  orders for all markets
  """
  defdelegate return_open_orders(currency_pair),
    to: Trading.ReturnOpenOrders,
    as: :return_open_orders

  @doc """
  Returns the past 200 trades for a given market, or up to 50,000 trades between 
  a range specified in UNIX timestamps by the "start" and "end" GET parameters.
  """
  defdelegate return_trade_history(currency_pair, start, to),
    to: Trading.ReturnTradeHistory,
    as: :return_trade_history

  @doc """
  Returns all trades involving a given order, specified by the "orderNumber" 
  POST parameter. If no trades for the order have occurred or you specify an 
  order that does not belong to you, you will receive an error
  """
  defdelegate return_order_trades(order_number),
    to: Trading.ReturnOrderTrades,
    as: :return_order_trades

  @doc """
  Returns the status of a given order, specified by the "orderNumber" POST parameter. 
  If the specified orderNumber is not open, or it is not yours, you will receive an error.
  """
  defdelegate return_order_status(order_number),
    to: Trading.ReturnOrderStatus,
    as: :return_order_status

  @doc """
  Places a limit buy order in a given market. Required POST parameters are 
  "currencyPair", "rate", and "amount". If successful, the method will return 
  the order number.
  You may optionally set "fillOrKill", "immediateOrCancel", "postOnly" to 1. 
  A fill-or-kill order will either fill in its entirety or be completely aborted. 
  An immediate-or-cancel order can be partially or completely filled, but any 
  portion of the order that cannot be filled immediately will be canceled rather 
  than left on the order book. A post-only order will only be placed if no 
  portion of it fills immediately; this guarantees you will never pay the taker 
  fee on any part of the order that fills.
  """
  defdelegate buy(
                currency_pair,
                rate,
                amount,
                order_type \\ nil
              ),
              to: Trading.Buy,
              as: :buy

  @doc """
  Places a sell order in a given market. Parameters and output are the same as 
  for the buy method.
  """
  defdelegate sell(
                currency_pair,
                rate,
                amount,
                order_type \\ nil
              ),
              to: Trading.Sell,
              as: :sell

  @doc """
  Cancels an order you have placed in a given market. Required POST parameter is "orderNumber"
  """
  defdelegate cancel_order(order_number),
    to: Trading.CancelOrder,
    as: :cancel_order

  @doc """
  Cancels all open orders in a given market or, if no market is provided, all open orders in all markets. 
  Optional parameter is "currencyPair". 
  If successful, the method will return a success of 1 along with a JSON array of orderNumbers representing the orders that were cancelled. 
  """

  def cancel_all_orders(currency_pair \\ nil) do
    case Api.trading(@cancel_all_orders, currencyPair: currency_pair) do
      {:ok, orders} -> {:ok, orders}
      {:error, _} = error -> error
    end
  end

  @doc """
  Cancels an order and places a new one of the same type in a single atomic transaction, 
  meaning either both operations will succeed or both will fail. 
  Required parameters: "orderNumber" and "rate".
  Optionally parameter: "amount", if you wish to change the amount of the new order. 
  "postOnly" or "immediateOrCancel" may be specified for exchange orders, but will have no effect on margin orders.
  """
  defdelegate move_order(
                order_number,
                rate,
                client_order_id \\ nil,
                order_type \\ nil,
                amount \\ nil
              ),
              to: Trading.MoveOrder,
              as: :move_order

  @doc """
  Immediately places a withdrawal for a given currency, with no email confirmation. 
  In order to use this method, withdrawal privilege must be enabled for your API key. 
  Required POST parameters are "currency", "amount", and "address".

  For withdrawals which support payment IDs, (such as XMR) you may optionally specify "paymentId".

  For currencies where there are multiple networks to choose from you need to specify 
  the param: currencyToWithdrawAs. For USDT use currencyToWithdrawAs=USDTTRON or USDTETH. 
  The default for USDT is Omni which is used if currencyToWithdrawAs is not specified.
  """
  def withdraw(currency, amount, address, payment_id \\ nil, currency_to_withdraw_as \\ nil) do
    case Api.trading(@withdraw,
           currencyPair: currency,
           amount: amount,
           address: address,
           payment_id: payment_id,
           currencyToWithdrawAs: currency_to_withdraw_as
         ) do
      {:ok, response} -> {:ok, response}
      {:error, _} = error -> error
    end
  end

  @doc """
  If you are enrolled in the maker-taker fee schedule, returns your current 
  trading fees and trailing 30-day volume in BTC. This information is updated 
  once every 24 hours
  """
  def return_fee_info do
    case Api.trading(@return_fee_info) do
      {:ok, fee_info} -> {:ok, fee_info}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns your balances sorted by account. 
  You may optionally specify the "account" POST parameter if you wish to fetch only 
  the balances of one account.
  """
  def return_available_account_balances do
    case Api.trading(@return_available_account_balances) do
      {:ok, available_account_balances} -> {:ok, available_account_balances}
      {:error, _} = error -> error
    end
  end

  def return_available_account_balances(:all) do
    case Api.trading(@return_available_account_balances, account: :all) do
      {:ok, available_account_balances} -> {:ok, available_account_balances}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns your current tradable balances for each currency in each market 
  for which margin trading is enabled.
  """
  def return_tradable_balances do
    case Api.trading(@return_tradable_balances) do
      {:ok, tradable_balances} -> {:ok, tradable_balances}
      {:error, _} = error -> error
    end
  end

  @doc """
  Transfers funds from one account to another.
  Eg. from your exchange account to your margin account.
  """
  def transfer_balance(currency, amount, from_account, to_account) do
    case Api.trading(@transfer_balance,
           currency: currency,
           amount: amount,
           fromAccount: from_account,
           toAccount: to_account
         ) do
      {:ok, transfer_message} -> {:ok, transfer_message}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns a summary of your entire margin account. This is the same information
  you will find in the Margin Account section of the Margin Trading page.
  """
  def return_margin_account_summary do
    case Api.trading(@return_margin_account_summary) do
      {:ok, margin_account_summary} -> {:ok, margin_account_summary}
      {:error, _} = error -> error
    end
  end

  @doc """
  Places a margin buy order in a given market. 
  Required parameters: "currencyPair", "rate", and "amount". 
  Optionally specify a maximum lending rate using the "lendingRate" parameter. 
  (the default "lendingRate" value is 0.02 which stands for 2% per day) 

  Note: "rate" * "amount" must be > 0.02 when creating or expanding a market. 
  If successful, the method will return the order number and any trades immediately resulting from your order.
  """
  def margin_buy(currency_pair, rate, amount, lending_rate \\ nil, client_order_id \\ nil) do
    case Api.trading(@margin_buy,
           currencyPair: currency_pair,
           rate: rate,
           lendingRate: lending_rate,
           amount: amount,
           clientOrderId: client_order_id
         ) do
      {:ok, margin_order} -> {:ok, margin_order}
      {:error, _} = error -> error
    end
  end

  @doc """
  Places a margin sell order in a given market.
  Required parameters: "currencyPair", "rate", and "amount". 
  Optionally specify a max lending rate using the "lendingRate" parameter. 
  (the default "lendingRate" value is 0.02 which stands for 2% per day)

  Note: "rate" * "amount" must be > 0.02, when creating or expanding a market.
  If successful, the method will return the order number and any trades immediately resulting from your order.
  """
  def margin_sell(currency_pair, rate, amount, lending_rate \\ nil, client_order_id \\ nil) do
    case Api.trading(@margin_sell,
           currencyPair: currency_pair,
           rate: rate,
           lendingRate: lending_rate,
           amount: amount,
           clientOrderId: client_order_id
         ) do
      {:ok, margin_order} -> {:ok, margin_order}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns information about your margin position in a given market, 
  specified by the "currencyPair" parameter.
  You may set "currencyPair" to "all" if you wish to fetch all of your margin positions at once. 
  """
  def get_margin_position(currency_pair) do
    case Api.trading(@get_margin_position, currencyPair: currency_pair) do
      {:ok, margin_position} -> {:ok, margin_position}
      {:error, _} = error -> error
    end
  end

  @doc """
  Closes your margin position in a given market (currencyPair) using a market order. 
  This call will also return success if you do not have an open position in the specified market.
  """
  def close_margin_position(currency_pair) do
    case Api.trading(@close_margin_position, currencyPair: currency_pair) do
      {:ok, margin_position} -> {:ok, margin_position}
      {:error, _} = error -> error
    end
  end

  @doc """
  Creates a loan offer for a given currency. 
  Required parameters: "currency", "amount", "duration" (from 2 to 60, inclusive), "autoRenew" (0 or 1), and "lendingRate".
  """
  def create_loan_offer(currency, amount, duration, auto_renew, lending_rate) do
    case Api.trading(@create_loan_offer,
           currency: currency,
           amount: amount,
           duration: duration,
           autoRenew: auto_renew,
           lendingRate: lending_rate
         ) do
      {:ok, loan_offer} -> {:ok, loan_offer}
      {:error, _} = error -> error
    end
  end

  @doc """
  Cancels a loan offer specified by the "orderNumber" parameter.
  """
  def cancel_loan_offer(order_number) do
    case Api.trading(@cancel_loan_offer, orderNumber: order_number) do
      {:ok, loan_offer} -> {:ok, loan_offer}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns your open loan offers for each currency.
  """
  def return_open_loan_offers do
    case Api.trading(@return_open_loan_offers) do
      {:ok, open_loan_offers} -> {:ok, open_loan_offers}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns your active loans for each currency.
  """
  def return_active_loans do
    case Api.trading(@return_active_loans) do
      {:ok, active_loans} -> {:ok, active_loans}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns your lending history within a time range specified by the "start" and "end" POST parameters as UNIX timestamps. 
  "limit" may also be specified to limit the number of rows returned.
  """
  def return_lending_history(%DateTime{} = start, %DateTime{} = to, limit \\ nil) do
    start_unix = DateTime.to_unix(start)
    end_unix = DateTime.to_unix(to)

    case Api.trading(@return_lending_history, start: start_unix, end: end_unix, limit: limit) do
      {:ok, lending_history} -> {:ok, lending_history}
      {:error, _} = error -> error
    end
  end

  @doc """
  Toggles the autoRenew setting on an active loan, specified by the "orderNumber" parameter. 
  If successful, "message" will indicate the new autoRenew setting.
  """
  def toggle_auto_renew(order_number) do
    case Api.trading(@toggle_auto_renew, orderNumber: order_number) do
      {:ok, message} -> {:ok, message}
      {:error, _} = error -> error
    end
  end
end
