defmodule ClothingDashboard.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias ClothingDashboard.Repo

  alias ClothingDashboard.Catalog.Product
  alias ClothingDashboard.Catalog.Tag

  def list_products do
    Repo.all(Product)
  end

  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:tags)
  end

  def get_product(id) do
    Product
    |> Repo.get(id)
    |> Repo.preload(:tags)
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def create_product_with_tags(%{"tags" => tag_names} = attrs) do
    tags =
      from(t in ClothingDashboard.Catalog.Tag,
        where: t.name in ^tag_names,
        select: t
      )
      |> Repo.all()

    %Product{}
    |> Product.changeset(Map.drop(attrs, ["tags"]))
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
  end



  def update_product_with_tags(product, %{"tags" => tag_names} = attrs) do
    # Convert string keys to atom keys
    atomized_attrs = for {key, val} <- Map.drop(attrs, ["tags"]), into: %{} do
      case key do
        "price" -> {:price, Decimal.new(val)}
        "stock" -> {:stock, String.to_integer(val)}
        _ -> {String.to_existing_atom(key), val}
      end
    end

    # Fetch or create tags (if any)
    tags =
      if Enum.any?(tag_names) do
        tag_names
        |> Enum.map(fn tag_name ->
          Repo.get_by(ClothingDashboard.Catalog.Tag, name: tag_name) ||
            Repo.insert!(%ClothingDashboard.Catalog.Tag{name: tag_name})
        end)
      else
        []
      end

    # Update the product and associate the tags
    product
    |> Repo.preload(:tags) # Ensure existing tags are preloaded
    |> Ecto.Changeset.change(atomized_attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.update()
  end

  # Fallback for when "tags" are not provided
  def update_product_with_tags(product, attrs) do
    # Convert string keys to atom keys
    atomized_attrs =
      for {key, val} <- attrs, into: %{} do
        case key do
          "price" -> {:price, Decimal.new(val)}
          "stock" -> {:stock, String.to_integer(val)}
          _ -> {String.to_existing_atom(key), val}
        end
      end

    # Update the product and explicitly clear tags
    product
    |> Repo.preload(:tags)
    |> Ecto.Changeset.change(atomized_attrs)
    |> Ecto.Changeset.put_assoc(:tags, [])
    |> Repo.update()
  end






  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def list_products_by_category(category) do
    Product
    |> where([p], p.category == ^category)
    |> Repo.all()
  end

  def list_all_categories do
    query =
      from p in Product,
      select: p.category,
      distinct: true

    Repo.all(query)
  end

  def list_all_tags do
    Repo.all(Tag)
  end

  def filter_products_by_tags(tag_names) do
    from(p in Product,
      join: t in assoc(p, :tags),
      where: t.name in ^tag_names,
      distinct: true,
      preload: [:tags]
    )
    |> Repo.all()
  end

  defp fetch_tags(%{"tags" => tag_ids}) do
    from(t in Tag, where: t.id in ^tag_ids) |> Repo.all()
  end

  defp fetch_tags(_), do: []

  def search_products(%{search_query: search_query, selected_category: selected_category, sort_by: sort_by}) do
    query =
      from p in Product,
        where: true

    # Filter by search query
    query =
      if search_query != "" do
        from p in query, where: ilike(p.title, ^"%#{search_query}%")
      else
        query
      end

    # Filter by category
    query =
      if selected_category != "" do
        from p in query, where: p.category == ^selected_category
      else
        query
      end

    # Sorting logic
    query =
      case sort_by do
        :price_asc -> from p in query, order_by: [asc: p.price]
        :price_desc -> from p in query, order_by: [desc: p.price]
        :stock_asc -> from p in query, order_by: [asc: p.stock]
        :stock_desc -> from p in query, order_by: [desc: p.stock]
        _ -> query
      end

    Repo.all(query)
  end

end
