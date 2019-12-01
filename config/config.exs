# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :techblog,
  domain: "localhost",
  extra_domains: "anunknown.local;10xdevelopers.local",
  acme_server: :local,
  port: 4000,
  ssl_port: 4001,
  host: "127.0.0.1"

# Configures the endpoint
config :techblog, TechblogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DCeSmGCfQ4FaWWwIS6ekfVmxISEPjsWyvrg2lbqvXLKCmaMxPlH9BfcmqVJeQvXR",
  render_errors: [view: TechblogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub: [name: Techblog.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "vDA35tDfoT5uyH6t/IfBHDqv4cx4UDCksD9Ve4F4wl2oNg6AacyoXIwrO8VA0A4m"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
