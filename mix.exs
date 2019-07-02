defmodule Techblog.MixProject do
  use Mix.Project

  def project do
    [
      app: :techblog,
      version: "0.3.26",
      elixir: "~> 1.5",
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
      extra_applications: [:logger, :runtime_tools, :telemetry]
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
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:diet, github: "pragdave/diet"},
      {:doex, "~> 0.9"},
      {:version_tasks, "~> 0.11"},
      {:site_encrypt, github: "aforward-oss/site_encrypt", branch: "f/num_acceptors"},
      {:fn_expr, "~> 0.3"},
      {:deferred_config, "~> 0.1.0"},
      {:earmark, "~> 1.3"},
      {:distillery, "~> 2.1"},
      {:telemetry, "~> 0.4.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
