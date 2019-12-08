defmodule PoloniexClient.Trading.ImmediateOrCancel do
  @moduledoc """
  An immediate-or-cancel order can be partially or completely filled, 
  but any portion of the order that cannot be filled immediately will
  be canceled rather than left on the order book
  """

  defstruct []
end
