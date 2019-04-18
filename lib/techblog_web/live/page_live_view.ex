defmodule TechblogWeb.PageLiveView do
  use Phoenix.LiveView
  import TechblogWeb.Gettext

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
    ~L"""
    <section class="phx-hero" data-tock="<%= @tock %>" style="background-color: <%= @bgcolor %>; color: <%= @fgcolor %>">
      <h1><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h1>
      <p>A productive web framework that<br/>does not compromise speed or maintainability.</p>
    </section>

    <section class="row">
      <article class="column">
        <h2>Resources</h2>
        <ul>
          <li>
            <a href="https://hexdocs.pm/phoenix/overview.html">Guides &amp; Docs</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix">Source</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix/blob/v1.4/CHANGELOG.md">v1.4 Changelog</a>
          </li>
        </ul>
      </article>
      <article class="column">
        <h2>Help</h2>
        <ul>
          <li>
            <a href="https://elixirforum.com/c/phoenix-forum">Forum</a>
          </li>
          <li>
            <a href="https://webchat.freenode.net/?channels=elixir-lang">#elixir-lang on Freenode IRC</a>
          </li>
          <li>
            <a href="https://twitter.com/elixirphoenix">Twitter @elixirphoenix</a>
          </li>
          <li>
            <a href="https://elixir-slackin.herokuapp.com/">Elixir on Slack</a>
          </li>
        </ul>
      </article>
    </section>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: tick()
    {:ok, socket |> assign(tock: 1000) |> assign_colours()}
  end

  def handle_info(:tick, socket) do
    tick()
    {:noreply, socket |> update(:tock, &(&1 + 1)) |> assign_colours()}
  end

  defp colour(), do: @colours |> Enum.random()

  defp assign_colours(socket) do
    socket
    |> assign(:bgcolor, colour())
    |> assign(:fgcolor, colour())
  end

  defp tick(), do: Process.send_after(self(), :tick, 1000)
end
