defmodule TechblogWeb.PageController do
  use TechblogWeb, :controller

  @slugs Techblog.slugs()
  @articles Techblog.articles()
  @summaries Techblog.summaries()

  def index(conn, params) do
    conn
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
    case Mix.env() do
      :dev -> Techblog.slugs()
      _ -> @slugs
    end
  end

  def articles() do
    case Mix.env() do
      :dev -> Techblog.articles()
      _ -> @articles
    end
  end

  def summaries() do
    case Mix.env() do
      :dev -> Techblog.summaries()
      _ -> @summaries
    end
  end
end
