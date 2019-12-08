defmodule PoloniexClient.NotEnoughError do
  @moduledoc """
  Returned when there is not enough base currency.
  """

  @enforce_keys [:message]
  defstruct [:message]
end
