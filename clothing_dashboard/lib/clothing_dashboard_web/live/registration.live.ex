defmodule ClothingDashboardWeb.RegistrationLive do
  use ClothingDashboardWeb, :live_view

  alias ClothingDashboard.Accounts
  alias ClothingDashboard.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <h1 class="text-2xl font-bold">Register</h1>
      <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4">
        <div>
          <label>Email:</label>
          <.input field={@form[:email]} type="email" class="border rounded px-2 py-1" />
        </div>

        <div>
          <label>Password:</label>
          <.input field={@form[:password]} type="password" class="border rounded px-2 py-1" />
        </div>

        <div>
          <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">
            Register
          </button>
        </div>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    form = to_form(Accounts.change_user(%User{}))
    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    form =
      %User{}
      |> Accounts.change_user(user_params)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    # Debugging to check if the "save" event fires and what params are passed
    IO.inspect(user_params, label: "Save Event Params")

    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User registered successfully.")
         |> push_navigate(to: "/login")}

      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "Registration Errors")
        form = to_form(changeset)
        {:noreply, assign(socket, form: form)}
    end
  end
end
