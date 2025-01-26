defmodule ClothingDashboard.Repo.Migrations.CreateTagsAndProductsTags do
  use Ecto.Migration

  def change do
    # Create tags table
    create table(:tags) do
      add :name, :string, null: false

      timestamps()
    end

    # Ensure tag names are unique
    create unique_index(:tags, [:name])

    # Create the join table for products and tags
    create table(:products_tags) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false

      timestamps()
    end

    # Ensure unique combinations of product_id and tag_id
    create unique_index(:products_tags, [:product_id, :tag_id])
  end
end
