defmodule ClothingDashboard.PageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClothingDashboard.Page` context.
  """

  @doc """
  Generate a home.
  """
  def home_fixture(attrs \\ %{}) do
    {:ok, home} =
      attrs
      |> Enum.into(%{

      })
      |> ClothingDashboard.Page.create_home()

    home
  end
end
