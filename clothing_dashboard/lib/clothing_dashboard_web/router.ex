defmodule ClothingDashboardWeb.Router do
  use ClothingDashboardWeb, :router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ClothingDashboardWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug :fetch_session
    plug :put_secure_browser_headers
    plug :require_authenticated_user
  end

  defp require_authenticated_user(conn, _opts) do
    if get_session(conn, :user_id) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: "/login")
      |> halt()
    end
  end

  # Public routes
  scope "/", ClothingDashboardWeb do
    pipe_through :browser

    live "/register", RegistrationLive, :index
    live "/login", LoginLive, :index
    get "/set_session/:user_id", PageController, :set_session
  end

  # Protected routes
  scope "/", ClothingDashboardWeb do
    pipe_through [:browser, :authenticated]

    live "/dashboard", DashboardLive
    live "/products_live", ProductsLive, :index
    live "/live_feed", LiveFeedLive, :index
    resources "/users", UserController
    resources "/products", ProductController
  end
end
