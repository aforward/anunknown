use Mix.Config

config :techblog,
  blog_mode: :reload,
  writing_assets: "assets",
  blog_path: "assets/blog"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :techblog, TechblogWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
