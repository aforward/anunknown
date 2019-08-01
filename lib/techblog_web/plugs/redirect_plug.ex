defmodule TechblogWeb.Plugs.RedirectPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if conn.host == "10xdevelopers.com" do
      conn
      |> put_status(:moved_permanently)
      |> Phoenix.Controller.redirect(external: canonical_domain())
      |> halt()
    else
      conn
    end
  end

  defp canonical_domain() do
    scheme = TechblogWeb.Endpoint.config(:url)[:scheme] || "http"
    host = TechblogWeb.Endpoint.config(:url)[:host] || "localhost"
    "#{scheme}://#{host}"
  end
end