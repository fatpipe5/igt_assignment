defmodule ClothingDashboard.Repo.Migrations.CreateHome do
  use Ecto.Migration

  def change do
    create table(:home) do

      timestamps(type: :utc_datetime)
    end
  end
end
