defmodule ClothingDashboardWeb.HomeController do
  use ClothingDashboardWeb, :controller

  def index(conn, _params) do
    # Fetch the current_user from the session if present
    current_user = get_session(conn, :user_id) && ClothingDashboard.Accounts.get_user!(get_session(conn, :user_id))
    conn
    |> assign(:current_user, current_user)
    |> render("index.html")
  end
end
