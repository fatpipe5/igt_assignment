defmodule ClothingDashboardWeb.ProductController do
  use ClothingDashboardWeb, :controller

  alias ClothingDashboard.Catalog
  alias ClothingDashboard.Catalog.Product
  alias ClothingDashboard.Repo

  def index(conn, params) do
    category_filter = Map.get(params, "category", "")
    products =
      if category_filter == "" do
        Catalog.list_products()
      else
        Catalog.list_products_by_category(category_filter)
      end

    categories = Catalog.list_all_categories()

    render(conn, :index, products: products, categories: categories)
  end

  def new(conn, _params) do
    changeset = Catalog.change_product(%Product{})
    categories = Catalog.list_all_categories()
    tags = Catalog.list_all_tags()

    render(conn, :new, changeset: changeset, categories: categories, tags: tags, selected_tags: [], action: ~p"/products")
  end

  def create(conn, %{"product" => product_params}) do
    case Catalog.create_product_with_tags(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors, label: "Changeset Errors")
        categories = Catalog.list_all_categories()
        tags = Catalog.list_all_tags()
        render(conn, :new, changeset: changeset, categories: categories, tags: tags, action: ~p"/products")
    end
  end


  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, :show, product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Catalog.get_product!(id) |> Repo.preload(:tags) # Preload tags
    changeset = Catalog.change_product(product)
    categories = Catalog.list_all_categories()
    tags = Catalog.list_all_tags() # Fetch all available tags

    render(conn, :edit,
      product: product,
      changeset: changeset,
      categories: categories,
      tags: tags
    )
  end




  def update(conn, %{"id" => id, "product" => product_params}) do
    IO.inspect(product_params, label: "Product Params")

    product = Catalog.get_product!(id) |> Repo.preload(:tags)

    case Catalog.update_product_with_tags(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Catalog.list_all_categories()
        tags = Catalog.list_all_tags()

        render(conn, :edit,
          product: product,
          changeset: changeset,
          categories: categories,
          tags: tags
        )
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
