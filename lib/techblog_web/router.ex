defmodule TechblogWeb.Router do
  use TechblogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TechblogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TechblogWeb do
    pipe_through :browser
    get("/", PageController, :index)
    get("/articles", PageController, :index)
    get("/articles/:slug", PageController, :show)

    get("/demo/flash", DemoController, :show_flash)

    live "/demo/empex", EmpexlogoLive
    live "/demo/hangman", HangmanLive
    live "/demo/hanoi", HanoiLive
    live "/demo/undo", UndoLive
    live "/demo/phoenix", PageLive, :index
    live "/leaderboard", LeaderboardLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TechblogWeb do
  #   pipe_through :api
  # end
end
