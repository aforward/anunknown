defmodule TechblogWeb.UndoLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""

    <style>
      .record {
        margin: 10px 0;
        padding: 20px;
      }
      .pending { background-color: red; }
      .ok { background-color: grey; }
      .phx-disconnected{
        opacity: 0.5;
        cursor: wait;
      }
      .phx-disconnected *{
        pointer-events: none;
      }

      .phx-error {
        background: #ffe6f0!important;
      }
    </style>

    <%= if @undo_counter > 0 do %>
      <button phx-click="undo">Undo <%= @undo_counter %>s</button>
    <% end %>

    <%= for {id, r} <- @records do %>
      <div class="record <%= r.status%>">
        <span><%= r.name %></span>
        <button phx-click="delete" phx-value="<%= id %>">Delete</button>
      </div>
    <% end %>
    """
  end

  def mount(_session, socket) do
    socket
    |> assign(:records, %{
      "1" => %{name: "Alice", status: "ok"},
      "2" => %{name: "Bob", status: "ok"},
      "3" => %{name: "Candice", status: "ok"}
    })
    |> assign(:pending_delete, [])
    |> assign(:undo_counter, 0)
    |> socket_reply(:ok)
  end

  def handle_event("undo", _, socket) do
    socket
    |> assign(:pending_delete, [])
    |> assign(:undo_counter, 0)
    |> update(:records, fn all ->
      all |> Enum.map(fn {id, r} -> {id, %{r | status: "ok"}} end) |> Enum.into(%{})
    end)
    |> socket_reply()
  end

  def handle_event("delete", id, %{assigns: %{undo_counter: time}} = socket) do
    if time == 0 do
      Process.send_after(self(), :countdown, 1000)
    end

    socket
    |> assign(:undo_counter, 5)
    |> update(:pending_delete, &[id | &1])
    |> update(:records, fn all -> all |> Map.update!(id, fn r -> %{r | status: "pending"} end) end)
    |> socket_reply()
  end

  def handle_info(
        :countdown,
        %{assigns: %{undo_counter: 0, records: records, pending_delete: deletes}} = socket
      ) do
    socket
    |> assign(
      :records,
      Enum.reject(records, fn {id, _r} -> Enum.member?(deletes, id) end) |> Enum.into(%{})
    )
    |> assign(:pending_delete, [])
    |> assign(:undo_counter, 0)
    |> socket_reply()
  end

  def handle_info(:countdown, socket) do
    Process.send_after(self(), :countdown, 1000)

    socket
    |> update(:undo_counter, &(&1 - 1))
    |> socket_reply()
  end

  defp socket_reply(socket, reply \\ :noreply), do: {reply, socket}
end
