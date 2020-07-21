# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :techblog,
  domain: "127.0.0.1",
  port: 4010,
  ssl_port: 4011,
  host: "127.0.0.1",
  blog_mode: :reload,
  blog_path: "assets/blog"

# Configures the endpoint
config :techblog, TechblogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DCeSmGCfQ4FaWWwIS6ekfVmxISEPjsWyvrg2lbqvXLKCmaMxPlH9BfcmqVJeQvXR",
  render_errors: [view: TechblogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Techblog.PubSub,
  live_view: [signing_salt: "vDA35tDfoT5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
