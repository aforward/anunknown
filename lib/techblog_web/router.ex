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
    get("/resume", PageController, :resume)
    get("/portfolio", PageController, :portfolio)
    get("/publications", PageController, :publications)
    get("/snippets", PageController, :snippets)

    get("/blog", BlogController, :index)
    get("/blog/:slug", BlogController, :show)
    get("/articles", BlogController, :index)
    get("/articles/:slug", BlogController, :show)

    get("/demo/flash", DemoController, :show_flash)

    live "/demo/empex", EmpexlogoLive
    live "/demo/hangman", HangmanLive
    live "/demo/hanoi", HanoiLive
    live "/demo/undo", UndoLive
    live "/demo/phoenix", PageLive, :index
    live "/leaderboard", LeaderboardLive

    live "/blog2", BlogLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TechblogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TechblogWeb.Telemetry
    end
  end
end
