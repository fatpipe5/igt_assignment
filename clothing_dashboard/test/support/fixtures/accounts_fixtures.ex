defmodule ClothingDashboard.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClothingDashboard.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> ClothingDashboard.Accounts.create_user()

    user
  end
end
