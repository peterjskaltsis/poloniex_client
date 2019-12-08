defmodule PoloniexClient.AuthenticationError do
  @moduledoc """
  Returned when API requests are not authenticated correctly.
  """

  @enforce_keys [:message]
  defstruct [:message]
end
