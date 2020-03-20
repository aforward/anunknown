defmodule TechblogWeb.EmpexlogoLiveTest do
  use TechblogWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconneted_html} = live(conn, "/demo/empex")
    assert disconneted_html =~ "<div class=\"empexlogo\" data-tock=\"1\">"
    assert render(page_live) =~ "<div class=\"empexlogo\" data-tock=\"1\">"
  end
end
