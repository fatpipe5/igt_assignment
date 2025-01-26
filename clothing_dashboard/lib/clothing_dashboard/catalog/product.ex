defmodule ClothingDashboard.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :title, :string
    field :category, :string
    field :photo, :string
    field :price, :decimal
    field :stock, :integer

    many_to_many :tags, ClothingDashboard.Catalog.Tag,
      join_through: ClothingDashboard.Catalog.ProductTag,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:photo, :title, :description, :category, :price, :stock])
    |> cast_assoc(:tags)
    |> validate_required([:photo, :title, :description, :category, :price, :stock])
  end
end
