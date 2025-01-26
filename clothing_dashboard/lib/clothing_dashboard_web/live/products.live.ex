defmodule ClothingDashboardWeb.ProductsLive do
  use ClothingDashboardWeb, :live_view

  alias ClothingDashboard.Catalog
  alias ClothingDashboard.Accounts
  alias ClothingDashboard.Catalog.Product
  import Ecto.Query
  alias ClothingDashboard.Repo


  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <!-- Search and Filter Section -->
      <div class="flex items-center justify-between">
        <.form for={%{}} as={:filters} phx-submit="search" class="flex items-center space-x-2">
          <label for="search_query" class="font-semibold whitespace-nowrap">
            Search by Title:
          </label>
          <.input
            field={:search_query}
            name="filters[search_query]"
            value={@search_query}
            type="text"
            class="border rounded px-2 py-1"
          />
          <button type="submit" class="bg-blue-500 text-white px-2 py-1 rounded text-sm">
            Search
          </button>
        </.form>

        <div>
          <a href={~p"/products/new"} class="bg-black text-white px-4 py-2 rounded shadow">
            New Product
          </a>
        </div>
      </div>

      <!-- Category Filter -->
      <div>
        <.form for={%{}} as={:filters} phx-change="filter_category" class="flex items-center space-x-4">
          <label for="selected_category" class="font-semibold">Category:</label>
          <select
            id="selected_category"
            name="filters[selected_category]"
            class="border rounded px-2 py-1"
          >
            <option value="" selected={@selected_category == ""}>All</option>
            <%= for cat <- @categories do %>
              <option value={cat} selected={@selected_category == cat}><%= cat %></option>
            <% end %>
          </select>
          <button type="submit" class="hidden"></button>
        </.form>
      </div>

      <!-- Tag Filter -->
      <div>
        <.form for={%{}} phx-change="filter_tags">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-2">
            <%= for tag <- @tags do %>
              <label class="inline-flex items-center space-x-2">
                <input
                  type="checkbox"
                  name="tags[]"
                  value={tag.name}
                  checked={tag.name in @selected_tags}
                />
                <span><%= tag.name %></span>
              </label>
            <% end %>
          </div>
        </.form>
      </div>

      <!-- Sorting Buttons -->
      <div class="flex space-x-4">
        <button
          class={if @sort_by == :price_asc, do: "bg-green-500 text-white px-4 py-1 rounded", else: "bg-gray-200 px-4 py-1 rounded"}
          phx-click="sort_by"
          phx-value-field="price"
          phx-value-order="asc"
        >
          Price Low to High
        </button>
        <button
          class={if @sort_by == :price_desc, do: "bg-green-500 text-white px-4 py-1 rounded", else: "bg-gray-200 px-4 py-1 rounded"}
          phx-click="sort_by"
          phx-value-field="price"
          phx-value-order="desc"
        >
          Price High to Low
        </button>
        <button
          class={if @sort_by == :stock_asc, do: "bg-green-500 text-white px-4 py-1 rounded", else: "bg-gray-200 px-4 py-1 rounded"}
          phx-click="sort_by"
          phx-value-field="stock"
          phx-value-order="asc"
        >
          Stock Low to High
        </button>
        <button
          class={if @sort_by == :stock_desc, do: "bg-green-500 text-white px-4 py-1 rounded", else: "bg-gray-200 px-4 py-1 rounded"}
          phx-click="sort_by"
          phx-value-field="stock"
          phx-value-order="desc"
        >
          Stock High to Low
        </button>
      </div>

      <!-- Products Table -->
      <table class="w-full border-collapse border border-gray-300 shadow">
        <thead>
          <tr class="bg-gray-100">
            <th class="border px-4 py-2">Photo</th>
            <th class="border px-4 py-2">Title</th>
            <th class="border px-4 py-2">Category</th>
            <th class="border px-4 py-2">Price</th>
            <th class="border px-4 py-2">Stock</th>
            <th class="border px-4 py-2 text-center">Actions</th>
          </tr>
        </thead>
        <tbody>
          <%= for product <- @products do %>
            <tr class="hover:bg-gray-50">
              <td class="border px-4 py-2">
                <img src={product.photo} alt={product.title} class="h-16 w-16 object-cover" />
              </td>
              <td class="border px-4 py-2"><%= product.title %></td>
              <td class="border px-4 py-2"><%= product.category %></td>
              <td class="border px-4 py-2"><%= product.price %></td>
              <td class="border px-4 py-2"><%= product.stock %></td>
              <td class="border px-4 py-2 text-center">
                <div class="flex justify-center space-x-2">
                  <button
                    class="bg-gray-500 text-white px-2 py-1 rounded"
                  >
                    Edit
                  </button>
                  <button
                    class="bg-gray-500 text-white px-2 py-1 rounded"
                    phx-click="delete_product"
                    phx-value-id={product.id}
                  >
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    if session["user_id"] do
      user = Accounts.get_user!(session["user_id"])
      tags = Catalog.list_all_tags()
      categories = Catalog.list_all_categories()

      # Load products initially
      products = load_products(%{
        search_query: "",
        selected_category: "",
        selected_tags: [], # Add selected_tags as an empty list
        sort_by: nil
      })

      {:ok,
      assign(socket,
        current_user: user,
        categories: categories,
        search_query: "",
        selected_category: "",
        tags: tags,
        selected_tags: [], # Ensure selected_tags is assigned
        sort_by: nil,
        products: products
      )}
    else
      {:ok,
      socket
      |> put_flash(:error, "Please log in to access products.")
      |> push_redirect(to: "/login")}
    end
  end




  @impl true
  def handle_event("search", %{"filters" => %{"search_query" => query}}, socket) do
    socket = assign(socket, :search_query, query)
    {:noreply, reload_products(socket)}
  end

  @impl true
  def handle_event("filter_category", %{"filters" => %{"selected_category" => category}}, socket) do
    socket =
      socket
      |> assign(:selected_category, category)

    {:noreply, reload_products(socket)}
  end

  @impl true
  def handle_event("filter_category", params, socket) do
    IO.inspect(params, label: "Filter Category Event Params")

    socket = assign(socket, :selected_category, params["filters"]["selected_category"])
    {:noreply, reload_products(socket)}
  end


  @impl true
  def handle_event("sort_by", %{"field" => field, "order" => order}, socket) do
    sort_key = String.to_atom("#{field}_#{order}")
    socket = assign(socket, :sort_by, sort_key)
    {:noreply, reload_products(socket)}
  end

  @impl true
  def handle_event("delete_product", %{"id" => id}, socket) do
    case Catalog.get_product(id) do
      nil -> {:noreply, socket} # If the product doesn't exist
      product ->
        {:ok, _deleted_product} = Catalog.delete_product(product)
        {:noreply, reload_products(socket)}
    end
  end

  @impl true
  def handle_event("filter_tags", %{"tags" => selected_tags}, socket) do
    selected_tags = Enum.uniq(selected_tags || [])

    socket =
      socket
      |> assign(:selected_tags, selected_tags)

    {:noreply, reload_products(socket)}
  end

  @impl true
  def handle_event("filter_tags", _params, socket) do
    socket =
      socket
      |> assign(:selected_tags, [])

    {:noreply, reload_products(socket)}
  end



  defp reload_products(socket) do
    IO.inspect(%{
      search: socket.assigns.search_query,
      category: socket.assigns.selected_category,
      tags: socket.assigns.selected_tags,
      sort_by: socket.assigns.sort_by
    }, label: "Reload Products Parameters")

    products = load_products(%{
      search_query: socket.assigns.search_query,
      selected_category: socket.assigns.selected_category,
      selected_tags: socket.assigns.selected_tags,
      sort_by: socket.assigns.sort_by
    })

    assign(socket, :products, products)
  end




  defp load_products(%{search_query: search_query, selected_category: selected_category, selected_tags: selected_tags, sort_by: sort_by}) do
    query =
      from p in Product,
        preload: [:tags]

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

    # Filter by tags
    query =
      if selected_tags != [] do
        from p in query,
          join: t in assoc(p, :tags),
          where: t.name in ^selected_tags,
          group_by: p.id,
          having: count(t.id) == ^length(selected_tags)
      else
        query
      end

    # Apply sorting
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
