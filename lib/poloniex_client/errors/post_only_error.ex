defmodule PoloniexClient.PostOnlyError do
  @moduledoc """
  Returned when no portion of an order fills immediately.
  """

  @enforce_keys [:message]
  defstruct [:message]
end
