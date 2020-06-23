defmodule TechblogWeb.GpayController do
  use TechblogWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end