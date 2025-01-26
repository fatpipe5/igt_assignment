defmodule ClothingDashboard.PageTest do
  use ClothingDashboard.DataCase

  alias ClothingDashboard.Page

  describe "home" do
    alias ClothingDashboard.Page.Home

    import ClothingDashboard.PageFixtures

    @invalid_attrs %{}

    test "list_home/0 returns all home" do
      home = home_fixture()
      assert Page.list_home() == [home]
    end

    test "get_home!/1 returns the home with given id" do
      home = home_fixture()
      assert Page.get_home!(home.id) == home
    end

    test "create_home/1 with valid data creates a home" do
      valid_attrs = %{}

      assert {:ok, %Home{} = home} = Page.create_home(valid_attrs)
    end

    test "create_home/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Page.create_home(@invalid_attrs)
    end

    test "update_home/2 with valid data updates the home" do
      home = home_fixture()
      update_attrs = %{}

      assert {:ok, %Home{} = home} = Page.update_home(home, update_attrs)
    end

    test "update_home/2 with invalid data returns error changeset" do
      home = home_fixture()
      assert {:error, %Ecto.Changeset{}} = Page.update_home(home, @invalid_attrs)
      assert home == Page.get_home!(home.id)
    end

    test "delete_home/1 deletes the home" do
      home = home_fixture()
      assert {:ok, %Home{}} = Page.delete_home(home)
      assert_raise Ecto.NoResultsError, fn -> Page.get_home!(home.id) end
    end

    test "change_home/1 returns a home changeset" do
      home = home_fixture()
      assert %Ecto.Changeset{} = Page.change_home(home)
    end
  end
end
