defmodule ClothingDashboardWeb.HomeControllerTest do
  use ClothingDashboardWeb.ConnCase

  import ClothingDashboard.PageFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all home", %{conn: conn} do
      conn = get(conn, ~p"/home")
      assert html_response(conn, 200) =~ "Listing Home"
    end
  end

  describe "new home" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/home/new")
      assert html_response(conn, 200) =~ "New Home"
    end
  end

  describe "create home" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/home", home: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/home/#{id}"

      conn = get(conn, ~p"/home/#{id}")
      assert html_response(conn, 200) =~ "Home #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/home", home: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Home"
    end
  end

  describe "edit home" do
    setup [:create_home]

    test "renders form for editing chosen home", %{conn: conn, home: home} do
      conn = get(conn, ~p"/home/#{home}/edit")
      assert html_response(conn, 200) =~ "Edit Home"
    end
  end

  describe "update home" do
    setup [:create_home]

    test "redirects when data is valid", %{conn: conn, home: home} do
      conn = put(conn, ~p"/home/#{home}", home: @update_attrs)
      assert redirected_to(conn) == ~p"/home/#{home}"

      conn = get(conn, ~p"/home/#{home}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, home: home} do
      conn = put(conn, ~p"/home/#{home}", home: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Home"
    end
  end

  describe "delete home" do
    setup [:create_home]

    test "deletes chosen home", %{conn: conn, home: home} do
      conn = delete(conn, ~p"/home/#{home}")
      assert redirected_to(conn) == ~p"/home"

      assert_error_sent 404, fn ->
        get(conn, ~p"/home/#{home}")
      end
    end
  end

  defp create_home(_) do
    home = home_fixture()
    %{home: home}
  end
end
