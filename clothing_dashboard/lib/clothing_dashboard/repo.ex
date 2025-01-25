defmodule ClothingDashboard.Repo do
  use Ecto.Repo,
    otp_app: :clothing_dashboard,
    adapter: Ecto.Adapters.Postgres
end
