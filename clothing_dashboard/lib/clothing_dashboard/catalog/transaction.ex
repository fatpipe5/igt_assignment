defmodule ClothingDashboard.Catalog.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :quantity, :integer
    belongs_to :product, ClothingDashboard.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:product_id, :quantity])
    |> validate_required([:product_id, :quantity])
  end
end
