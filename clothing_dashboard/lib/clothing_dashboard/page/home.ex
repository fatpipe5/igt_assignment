defmodule ClothingDashboard.Page.Home do
  use Ecto.Schema
  import Ecto.Changeset

  schema "home" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(home, attrs) do
    home
    |> cast(attrs, [])
    |> validate_required([])
  end
end
