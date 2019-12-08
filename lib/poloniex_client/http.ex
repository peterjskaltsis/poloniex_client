defmodule PoloniexClient.Http do
  @moduledoc """
  HTTP client to manage requests to Poloniex API methods
  - nonce uses :os.system_time
  - signed body uses sha512 from erlang crypto
  """

  @base_url "https://poloniex.com"

  # Main Functions

  @doc """
  The GET request function to send to a "/path", with a given Poloniex "command" and the "params" of that command.

  ## Examples

      iex> get("/public", "returnTicker", "")
      %{}

  """
  def get(path, command, params) do
    headers = []
    merged_params = Map.merge(%{command: command}, params)

    case HTTPoison.get(path |> url, headers, params: merged_params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        handle_ok(response_body)

      errors ->
        errors
    end
  end

  @doc """
  The POST request function to send to a "/path", with a given Poloniex "command" and the "params" of that command.

  ## Examples

      iex> post("/tradingApi", "returnOpenOrders", [currencyPair: "USDC_BTC"])
      %{}

  """
  def post(path, command, params) do
    param_pairs =
      Enum.map(params, fn {key, value} ->
        "#{key}=#{value}"
      end)

    post_body =
      ["nonce=#{nonce()}", "command=#{command}" | param_pairs]
      |> Enum.join("&")

    with {:ok, headers} <- sign_post_headers(post_body) do
      case HTTPoison.post(path |> url, post_body, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
          handle_ok(response_body)

        {:ok, %HTTPoison.Response{status_code: 403, body: response_body}} ->
          handle_forbidden(response_body)

        {:ok, %HTTPoison.Response{status_code: 422, body: response_body}} ->
          handle_unprocessable_entity(response_body)

        {:ok, %HTTPoison.Response{status_code: 429, body: response_body}} ->
          handle_unprocessable_entity(response_body)

        errors ->
          errors
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end

  # Helper Functions

  defp handle_ok(response_body) do
    response_body
    |> Jason.decode()
    |> case do
      {:ok, %{"error" => message}} ->
        {:error, message}

      {:ok, %{"result" => %{"error" => message}, "success" => 0}} ->
        {:error, message}

      {:ok, body} ->
        {:ok, body}

      {:error, _} = error ->
        error
    end
  end

  defp handle_unprocessable_entity(response_body) do
    response_body
    |> Jason.decode()
    |> case do
      {:ok, %{"error" => message}} ->
        {:error, message}

      {:error, _} = error ->
        error
    end
  end

  defp handle_forbidden(response_body) do
    response_body
    |> Jason.decode()
    |> case do
      {:ok, %{"error" => message}} ->
        {:error, %PoloniexClient.AuthenticationError{message: message}}

      {:error, _} = error ->
        error
    end
  end

  defp key do
    Application.get_env(:poloniex_client, :api_key, :error)
  end

  defp nonce do
    :os.system_time()
  end

  defp secret do
    Application.get_env(:poloniex_client, :api_secret, :error)
  end

  defp sign(text) do
    case secret() do
      :error ->
        :error

      _ ->
        :sha512
        |> :crypto.hmac(secret(), text)
        |> Base.encode16()
    end
  end

  defp sign_post_headers(body) do
    if key() != :error && sign(body) != :error do
      {:ok,
       [
         {"Content-Type", "application/x-www-form-urlencoded"},
         {"Key", key()},
         {"Sign", sign(body)}
       ]}
    else
      {:error, "Config error! Invalid secret or API key"}
    end
  end

  defp url(path) do
    "#{@base_url}/#{path}"
  end
end
