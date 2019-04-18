defmodule TechblogWeb.PageController do
  use TechblogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
