defmodule PoloniexClient.Trading.DepositsAndWithdrawals do
  @moduledoc false

  @enforce_keys [:deposits, :withdrawals]
  defstruct [:deposits, :withdrawals]
end
