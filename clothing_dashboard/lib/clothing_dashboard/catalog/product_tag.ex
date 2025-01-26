defmodule ClothingDashboard.Catalog.ProductTag do
  use Ecto.Schema

  schema "products_tags" do
    belongs_to :product, ClothingDashboard.Catalog.Product
    belongs_to :tag, ClothingDashboard.Catalog.Tag

    timestamps(type: :utc_datetime)
  end
end
