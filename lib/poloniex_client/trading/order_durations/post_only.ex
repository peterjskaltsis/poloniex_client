defmodule PoloniexClient.Trading.PostOnly do
  @moduledoc """
  A post-only order will only be placed if no portion of it fills immediately; 
  this guarantees you will never pay the taker fee on any part of the order that fills.
  """

  defstruct []
end
