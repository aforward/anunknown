defmodule TechblogWeb.Plugs.RedirectPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    case conn.host do
      "10xdevelopers.local" ->
        conn
        |> put_status(:moved_permanently)
        |> Phoenix.Controller.redirect(external: "http://anunknown.local:4000")
        |> halt()
      "10xdevelopers.com" ->
        conn
        |> put_status(:moved_permanently)
        |> Phoenix.Controller.redirect(external: canonical_domain())
        |> halt()
      _ ->
        conn
    end
  end

  defp canonical_domain() do
    scheme = TechblogWeb.Endpoint.config(:url)[:scheme] || "http"
    host = TechblogWeb.Endpoint.config(:url)[:host] || "localhost"
    "#{scheme}://#{host}"
  end
end
