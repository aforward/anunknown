defmodule TechblogWeb.BlogControllerTest do
  use TechblogWeb.ConnCase

  test "GET /blog", %{conn: conn} do
    conn = get(conn, "/blog")
    assert html_response(conn, 200) =~ "v"
  end
end
