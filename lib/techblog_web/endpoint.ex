defmodule TechblogWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :techblog
  use FnExpr

  socket "/socket", TechblogWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :techblog,
    gzip: true,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger
  plug SiteEncrypt.AcmeChallenge, TechblogWeb.Certbot

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_techblog_key",
    signing_salt: "qF5BEhB6"

  plug TechblogWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    port = Application.get_env(:techblog, :port)
    host = Application.get_env(:techblog, :host)
    ssl_port = Application.get_env(:techblog, :ssl_port)

    config
    |> Keyword.put(:url, host: host, port: port)
    |> Keyword.put(:http, [:inet6, port: port])
    |> invoke(fn cfg ->
      case TechblogWeb.Certbot.https_keys() do
        [] ->
          cfg
          |> Keyword.put(:https, false)

        keys ->
          if File.exists?(keys[:keyfile]) do
            cfg
            |> Keyword.put(:https, [port: ssl_port] ++ keys)
          else
            cfg |> Keyword.put(:https, false)
          end
      end
    end)
    |> invoke({:ok, &1})
  end
end
