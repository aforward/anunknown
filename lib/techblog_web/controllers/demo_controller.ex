defmodule TechblogWeb.DemoController do
  use TechblogWeb, :controller

  def show_flash(conn, _params) do
    conn
    |> put_flash(:info, %{title: "Welcome to Phoenix", subtitle: "One time flash info!"})
    |> render("flash.html")
  end

end