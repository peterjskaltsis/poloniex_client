defmodule PoloniexClient.FillOrKillError do
  @moduledoc """
  Returned when an order is not *entirely* filled.
  """

  @enforce_keys [:message]
  defstruct [:message]
end
