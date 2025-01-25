defmodule ClothingDashboard.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :quantity, :integer, null: false

      timestamps() # This automatically adds `inserted_at` and `updated_at`
    end
  end
end
