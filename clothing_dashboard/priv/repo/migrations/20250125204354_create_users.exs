defmodule ClothingDashboard.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    if index_exists?(:users, [:email]) do
      drop index(:users, [:email])
    end

    drop table(:users)
  end

  defp index_exists?(table, columns) do
    query = """
    SELECT to_regclass('#{table}_#{Enum.join(columns, "_")}_index')
    """
    ClothingDashboard.Repo.query!(query).rows != [[nil]]
  end
end
