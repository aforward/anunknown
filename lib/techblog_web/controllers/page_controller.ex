defmodule TechblogWeb.PageController do
  use TechblogWeb, :controller
  plug :put_layout, "page.html"

  def index(conn, _params) do
    conn
    |> assign(:page_id, :home)
    |> render("index.html", layout: {TechblogWeb.LayoutView, "app.html"})
  end

  def resume(conn, _params) do
    conn
    |> assign(:page_id, :resume)
    |> render("resume.html")
  end

  def portfolio(conn, _params) do
    conn
    |> assign(:page_id, :portfolio)
    |> render("portfolio.html")
  end

  def publications(conn, _params) do
    conn
    |> assign(:page_id, :publications)
    |> render("publications.html")
  end

  def snippets(conn, _params) do
    conn
    |> assign(:page_id, :snippets)
    |> render("snippets.html")
  end
end
