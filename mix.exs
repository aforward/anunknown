defmodule Techblog.MixProject do
  use Mix.Project

  def project do
    [
      app: :techblog,
      version: "0.3.61",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Techblog.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix", override: true},
      {:phoenix_live_view, "~> 0.10.0"},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:diet, github: "pragdave/diet"},
      {:doex, "~> 0.10"},
      {:version_tasks, "~> 0.11"},
      {:fn_expr, "~> 0.3"},
      {:deferred_config, "~> 0.1.0"},
      {:earmark, "~> 1.3"},
      {:distillery, "~> 2.1"}
    ]
  end
end
