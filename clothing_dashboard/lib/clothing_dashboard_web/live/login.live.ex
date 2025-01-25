defmodule ClothingDashboardWeb.LoginLive do
  use ClothingDashboardWeb, :live_view
  alias ClothingDashboard.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center min-h-screen bg-white-100">
      <div class="w-full max-w-md bg-white p-8 rounded shadow">
        <h2 class="text-2xl font-bold mb-6 text-center">Login</h2>
        <%= if @error do %>
          <div class="text-red-500 text-sm mb-4"><%= @error %></div>
        <% end %>
        <.form for={%{}} phx-submit="login" class="space-y-4">
          <div>
            <label for="email" class="block text-sm font-semibold">Email:</label>
            <input
              type="email"
              id="email"
              name="email"
              value={@email}
              class="w-full border px-4 py-2 rounded focus:outline-none"
            />
          </div>
          <div>
            <label for="password" class="block text-sm font-semibold">Password:</label>
            <input
              type="password"
              id="password"
              name="password"
              value={@password}
              class="w-full border px-4 py-2 rounded focus:outline-none"
            />
          </div>
          <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
            Login
          </button>
        </.form>

        <div class="pt-4">
          <p class="text-sm text-gray-600">
            Don't have an account?
            <a href="/register" class="text-blue-500 hover:underline">Register a new account</a>
          </p>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    if session["user_id"] do
      {:ok, push_redirect(socket, to: "/dashboard")}
    else
      {:ok, assign(socket, email: "", password: "", error: nil)}
    end
  end

  @impl true
  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        # Send a request to set the session via a controller
        {:noreply,
         socket
         |> put_flash(:info, "Welcome back, #{user.email}!")
         |> push_redirect(to: "/set_session/#{user.id}")}

      {:error, _reason} ->
        {:noreply, assign(socket, :error, "Invalid email or password")}
    end
  end
end
