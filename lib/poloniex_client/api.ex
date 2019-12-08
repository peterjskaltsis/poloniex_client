defmodule PoloniexClient.Api do
  @moduledoc """
  Module that routes trading and public API calls to their appropriate URLs.
  """

  # Requests Adapter
  @adapter PoloniexClient.Http

  # Poloniex Public and Private API Paths
  @public_path "public"
  @private_path "tradingApi"

  @doc """
  Function that submits a HTTP Request to the private/trading Poloniex API.
  """
  def trading(command, params) do
    params = Enum.filter(params, fn {_, val} -> val != nil end)
    @adapter.post(@private_path, command, params)
  end

  @doc false
  def trading(command) do
    trading(command, %{})
  end

  @doc """
  Function that submits a HTTP Request to the public Poloniex API.
  """
  def public(command, params) do
    params_map =
      params
      |> Enum.filter(fn {_, val} -> val != nil end)
      |> Enum.into(%{})

    @adapter.get(@public_path, command, params_map)
  end

  @doc false
  def public(command) do
    public(command, %{})
  end
end
