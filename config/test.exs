import Config

config :techblog,
  blog_mode: :reload,
  writing_assets: "assets",
  books_path: "assets/books",
  blog_path: "assets/blog"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :techblog, TechblogWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RWmEwcZMjafeGXcOvxbfTzaPU5dsiVztf6Gg4Ulh0CN/FeK6z+2u/zalBjMyw9ml",
  server: false

# In test we don't send emails.
config :techblog, Techblog.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
