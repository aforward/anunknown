defmodule TechblogWeb.PageController do
  use TechblogWeb, :controller

  @slugs Techblog.slugs()

  @articles Techblog.articles()

  @summaries Techblog.summaries()

  def index(conn, _params) do
    conn
    |> assign(:slugs, @slugs)
    |> assign(:summaries, @summaries)
    |> render("index.html")
  end

  def show(conn, %{"slug" => slug}) do
    case @slugs[slug] do
      nil ->
        redirect(conn, to: "/")

      _details ->
        conn
        |> assign(:slug, slug)
        |> assign(:article, @articles[slug])
        |> render("show.html")
    end
  end
end
