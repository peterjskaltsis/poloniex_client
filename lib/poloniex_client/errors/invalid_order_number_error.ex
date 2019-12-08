defmodule PoloniexClient.InvalidOrderNumberError do
  @moduledoc """
  Returned when the order number doesn't exist or is of an invalid format
  """

  @enforce_keys [:message]
  defstruct [:message]
end
