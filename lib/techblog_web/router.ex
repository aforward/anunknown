defmodule TechblogWeb.Router do
  use TechblogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TechblogWeb do
    pipe_through(:browser)
    get("/", PageController, :index)
    get("/articles", PageController, :index)
    get("/articles/:slug", PageController, :show)

    get("/demo/flash", DemoController, :show_flash)

    live "/demo/empex", EmpexlogoLiveView
    live "/demo/hangman", HangmanLiveView
    live "/demo/hanoi", HanoiLiveView
    live "/demo/undo", UndoLiveView
  end
end
