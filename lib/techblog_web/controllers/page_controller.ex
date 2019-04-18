defmodule TechblogWeb.PageController do
  use TechblogWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.Controller.live_render(conn, TechblogWeb.PageLiveView, session: %{})
  end
end
