defmodule ClothingDashboardWeb.PageController do
  use ClothingDashboardWeb, :controller

  def set_session(conn, %{"user_id" => user_id}) do
    conn
    |> put_session(:user_id, user_id)
    |> configure_session(renew: true) # Regenerate session ID for security
    |> redirect(to: "/dashboard")
  end
end
