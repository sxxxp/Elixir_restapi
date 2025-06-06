defmodule Restapi.MixProject do
  use Mix.Project

  def project do
    [
      app: :restapi,
      version: "0.1.0",
      elixir: "~> 1.18.3",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        restapi: [
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MyApp.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.0"},
      {:bandit, "~> 1.0"},
      {:dotenvy, "~> 0.8.0"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:websock, "~> 0.5"},
      {:websock_adapter, "~> 0.5.8"},
      {:ecto_sql, "~> 3.12"},
      {:postgrex, ">= 0.20.0"},
      {:pbkdf2_elixir, "~> 2.0"},
      {:cors_plug, "~> 3.0"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
