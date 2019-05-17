defmodule TechblogWeb.EmpexlogoLiveView do
  use Phoenix.LiveView

  @colours [
    "#5ED0FA",
    "#54D1DB",
    "#A368FC",
    "#F86A6A",
    "#FADB5F",
    "#65D6AD",
    "#127FBF",
    "#0E7C86",
    "#690CB0",
    "#AB091E",
    "#CB6E17",
    "#147D64"
  ]

  def render(assigns) do
    TechblogWeb.DemoView.render("empexlogo.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: tick()
    {:ok, socket |> assign(tock: 1) |> assign_colours()}
  end

  def handle_info(:tick, socket) do
    tick()
    {:noreply, socket |> update(:tock, &(&1 + 1)) |> assign_colours()}
  end

  defp colour(), do: @colours |> Enum.random()

  defp tick(), do: Process.send_after(self(), :tick, 1000)

  defp assign_colours(socket) do
    socket
    |> assign(:e1, colour())
    |> assign(:m, colour())
    |> assign(:p, colour())
    |> assign(:e2, colour())
    |> assign(:x, colour())
    |> assign(:top_diamond_1, colour())
    |> assign(:top_diamond_2, colour())
    |> assign(:top_diamond_3, colour())
    |> assign(:top_diamond_4, colour())
    |> assign(:top_diamond_5, colour())
    |> assign(:bottom_diamond_1, colour())
    |> assign(:bottom_diamond_2, colour())
    |> assign(:bottom_diamond_3, colour())
    |> assign(:bottom_diamond_4, colour())
    |> assign(:bottom_diamond_5, colour())
    |> assign(:top_outline, colour())
    |> assign(:bottom_outline, colour())
  end
end
