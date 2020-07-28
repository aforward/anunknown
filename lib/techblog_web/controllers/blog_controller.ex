defmodule TechblogWeb.BlogController do
  use TechblogWeb, :controller

  @slugs Techblog.slugs()
  @articles Techblog.articles()
  @summaries Techblog.summaries()
  @tags Techblog.tags()

  def index(conn, params) do
    conn
    |> assign(:page_id, :blog)
    |> assign(:tags, tags())
    |> assign(:slugs, slugs() |> Techblog.filter(params["tags"]) |> Techblog.sort())
    |> assign(:summaries, summaries() |> Techblog.filter(params["tags"]) |> Techblog.sort())
    |> render("index.html")
  end

  def show(conn, %{"slug" => slug}) do
    case slugs()[slug] do
      nil ->
        redirect(conn, to: "/")

      _details ->
        conn
        |> assign(:slug, slug)
        |> assign(:article, articles()[slug])
        |> render("show.html")
    end
  end

  def slugs() do
    case Application.get_env(:techblog, :blog_mode) do
      :reload -> Techblog.slugs()
      _ -> @slugs
    end
  end

  def articles() do
    case Application.get_env(:techblog, :blog_mode) do
      :reload -> Techblog.articles()
      _ -> @articles
    end
  end

  def summaries() do
    case Application.get_env(:techblog, :blog_mode) do
      :reload -> Techblog.summaries()
      _ -> @summaries
    end
  end

  def tags() do
    case Application.get_env(:techblog, :blog_mode) do
      :reload -> Techblog.tags()
      _ -> @tags
    end
  end
end
