defmodule ClothingDashboardWeb.LiveFeedLive do
  use ClothingDashboardWeb, :live_view

  alias ClothingDashboard.LiveFeed

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <h1 class="text-2xl font-bold">Live Feed</h1>

      <%= if @current_user do %>
        <p>Welcome, <%= @current_user.email %>!</p>
      <% else %>
        <p>Please log in to participate.</p>
      <% end %>

      <.form for={%{}} phx-submit="post_update">
        <textarea
          name="message"
          placeholder="Write your message..."
          class="w-full border rounded px-4 py-2"
        ></textarea>
        <button class="bg-blue-500 text-white px-4 py-2 rounded">Post Update</button>
      </.form>

      <div class="mt-6 space-y-4">
        <h2 class="text-lg font-bold">Updates:</h2>
        <%= for update <- @updates do %>
          <div class="p-4 bg-gray-100 rounded shadow">
            <p><strong><%= update.user %>:</strong> <%= update.message %></p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    if connected?(socket), do: LiveFeed.subscribe()

    user = ClothingDashboard.Accounts.get_user!(user_id) # Fetch the current user

    {:ok, assign(socket, current_user: user, updates: [])}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> put_flash(:error, "Please log in to access the live feed.")
    |> push_redirect(to: "/login")}
  end


  @impl true
  def handle_info({:new_update, update}, socket) do
    {:noreply, assign(socket, :updates, [update | socket.assigns.updates])}
  end

  @impl true
  def handle_event("post_update", %{"message" => message}, socket) do
    update = %{
      user: socket.assigns.current_user.email,
      message: message,
      timestamp: DateTime.utc_now()
    }

    LiveFeed.broadcast_update(update)
    {:noreply, socket}
  end
end
