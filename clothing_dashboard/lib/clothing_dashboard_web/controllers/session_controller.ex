defmodule ClothingDashboardWeb.SessionController do
  use ClothingDashboardWeb, :controller

  # Log the user out
  def delete(conn, _params) do
    conn
    |> configure_session(drop: true) # Drop the session
    |> redirect(to: "/login") # Redirect to your login or homepage
  end
end
