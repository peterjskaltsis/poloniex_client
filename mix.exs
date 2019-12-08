defmodule PoloniexClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :poloniex_client,
      version: "0.0.1",
      elixir: "~> 1.9",
      package: package(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger]
    ]
  end

  # Dynamic description
  defp description do
    "Poloniex Public/Trade API Elixir Client"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:castore, "~> 0.1.0"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:exvcr, "~> 0.10", only: :test},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:timex, "~> 3.5"}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Peter Skaltsis"],
      links: %{"GitHub" => "https://github.com/p-skal/poloniex_client"}
    }
  end
end
