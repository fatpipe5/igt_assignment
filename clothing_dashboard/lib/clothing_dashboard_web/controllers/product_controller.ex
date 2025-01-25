defmodule ClothingDashboardWeb.ProductController do
  use ClothingDashboardWeb, :controller

  alias ClothingDashboard.Catalog
  alias ClothingDashboard.Catalog.Product

  def index(conn, params) do
    # 1. Extract "category" from query params. Defaults to "" if none is given.
    category_filter = Map.get(params, "category", "")

    # 2. Conditionally filter the products
    products =
      if category_filter == "" do
        Catalog.list_products()
      else
        Catalog.list_products_by_category(category_filter)
      end

    # 3. We need a list of categories for the dropdown
    categories = Catalog.list_all_categories()

    # 4. Render the 'index.html.heex' template, passing products & categories
    render(conn, :index, products: products, categories: categories)
  end

  def new(conn, _params) do
    changeset = Catalog.change_product(%Product{})
    categories = Catalog.list_all_categories()

    render(conn, :new, changeset: changeset, categories: categories, action: ~p"/products")
  end

  def create(conn, %{"product" => product_params}) do
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Catalog.list_all_categories()
        render(conn, :new, changeset: changeset, categories: categories, action: ~p"/products")

    end
  end

  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, :show, product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    changeset = Catalog.change_product(product)
    categories = Catalog.list_all_categories()

    render(conn, :edit, product: product, changeset: changeset, categories: categories, action: ~p"/products")
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Catalog.get_product!(id)
    categories = Catalog.list_all_categories()

    case Catalog.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, product: product, changeset: changeset, categories: categories, action: ~p"/products")
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    {:ok, _product} = Catalog.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: ~p"/products")
  end
end
