defmodule PoloniexClient.Trading.OpenOrder do
  @moduledoc false

  @enforce_keys [:amount, :date, :margin, :order_number, :rate, :starting_amount, :total, :type]
  defstruct [:amount, :date, :margin, :order_number, :rate, :starting_amount, :total, :type]
end
