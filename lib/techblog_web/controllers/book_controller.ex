defmodule TechblogWeb.BookController do
  use TechblogWeb, :controller

  @slugs Techblog.Book.slugs()

  def index(conn, params) do
    conn
    |> assign(:page_id, :blog)
    |> assign(:slugs, slugs() |> Techblog.filter(params["tags"]) |> Techblog.sort())
    |> render("index.html")
  end

  def slugs() do
    case Application.get_env(:techblog, :blog_mode) do
      :reload -> Techblog.Book.slugs()
      _ -> @slugs
    end
  end
end
