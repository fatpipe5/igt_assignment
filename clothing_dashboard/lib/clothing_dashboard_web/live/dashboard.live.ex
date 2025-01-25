defmodule ClothingDashboardWeb.DashboardLive do
  use ClothingDashboardWeb, :live_view
  import Ecto.Query
  alias ClothingDashboard.Catalog
  alias ClothingDashboard.Repo
  alias ClothingDashboard.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <!-- Header -->
      <h1 class="text-2xl font-bold">Dashboard</h1>

      <!-- Filters -->
      <div class="flex items-center space-x-4">
        <label for="month" class="font-semibold">Filter by Month:</label>
        <.form phx-change="filter_month" for={%{}}>
          <select
            id="month"
            name="month"
            class="border rounded px-2 py-1"
          >
            <option value="" selected>All</option>
            <%= for month <- 1..12 do %>
              <option value={month}><%= ClothingDashboardWeb.MyCalendar.month_name(month) %></option>
            <% end %>
          </select>
        </.form>
      </div>

      <!-- Statistics -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Total Products in Stock -->
        <div class="p-4 bg-white rounded shadow">
          <h2 class="text-lg font-bold">Total Products in Stock</h2>
          <p class="text-xl"><%= @total_products_in_stock %></p>
        </div>

        <!-- Best-Selling Product -->
        <div class="p-4 bg-white rounded shadow">
          <h2 class="text-lg font-bold">Best Selling Product</h2>
          <%= if @best_selling_product do %>
            <p class="text-xl"><%= @best_selling_product.product %></p>
            <p class="text-sm text-gray-500">Sold: <%= @best_selling_product.total_sold %></p>
          <% else %>
            <p class="text-gray-500">No sales data available</p>
          <% end %>
        </div>

        <!-- Total Transactions -->
        <div class="p-4 bg-white rounded shadow">
          <h2 class="text-lg font-bold">Total Transactions</h2>
          <p class="text-xl"><%= @total_transactions %></p>
        </div>
      </div>

      <!-- Transactions Table -->
      <div class="mt-6">
        <h2 class="text-lg font-bold mb-4">Transactions</h2>
        <table class="min-w-full border-collapse border border-gray-300 shadow">
          <thead>
            <tr class="bg-gray-100">
              <th class="border px-4 py-2">Product</th>
              <th class="border px-4 py-2">Quantity</th>
              <th class="border px-4 py-2">Date</th>
            </tr>
          </thead>
          <tbody>
            <%= for transaction <- @transactions do %>
              <tr class="hover:bg-gray-50">
                <td class="border px-4 py-2"><%= transaction.product %></td>
                <td class="border px-4 py-2"><%= transaction.quantity %></td>
                <td class="border px-4 py-2"><%= transaction.date %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    if session["user_id"] do
      # Fetch the user and stats if the user is authenticated
      user = Accounts.get_user!(session["user_id"])
      stats = fetch_statistics()

      {:ok,
       socket
       |> assign(:current_user, user) # Assign the current user
       |> assign(:total_products_in_stock, stats.total_products_in_stock)
       |> assign(:best_selling_product, stats.best_selling_product)
       |> assign(:total_transactions, stats.total_transactions)
       |> assign(:transactions, stats.transactions)}
    else
      # Redirect if not authenticated
      {:ok,
       socket
       |> put_flash(:error, "Please log in to access the dashboard.")
       |> push_redirect(to: "/login")}
    end
  end

  @impl true
  def handle_event("filter_month", %{"month" => month}, socket) do
    stats =
      if month == "" do
        fetch_statistics(nil)
      else
        fetch_statistics(String.to_integer(month))
      end

    {:noreply,
     socket
     |> assign(:total_products_in_stock, stats.total_products_in_stock)
     |> assign(:best_selling_product, stats.best_selling_product)
     |> assign(:total_transactions, stats.total_transactions)
     |> assign(:transactions, stats.transactions)}
  end

  defp fetch_statistics(month \\ nil) do
    # Total products in stock
    total_products_in_stock = Repo.aggregate(Catalog.Product, :sum, :stock) || 0

    # Best-selling product query
    best_selling_product_query =
      if month do
        from t in Catalog.Transaction,
          join: p in assoc(t, :product),
          where: fragment("EXTRACT(MONTH FROM ?) = ?", t.inserted_at, ^month),
          group_by: p.id,
          select: %{product: p.title, total_sold: sum(t.quantity)},
          order_by: [desc: sum(t.quantity)],
          limit: 1
      else
        from t in Catalog.Transaction,
          join: p in assoc(t, :product),
          group_by: p.id,
          select: %{product: p.title, total_sold: sum(t.quantity)},
          order_by: [desc: sum(t.quantity)],
          limit: 1
      end

    best_selling_product = Repo.one(best_selling_product_query)

    # Total transactions query
    transactions_query =
      if month do
        from t in Catalog.Transaction,
          where: fragment("EXTRACT(MONTH FROM ?) = ?", t.inserted_at, ^month)
      else
        from t in Catalog.Transaction
      end

    total_transactions = Repo.aggregate(transactions_query, :count, :id) || 0

    # Fetch transactions for the table
    transactions_query_with_product =
      from t in transactions_query,
        join: p in assoc(t, :product),
        select: %{product: p.title, quantity: t.quantity, date: t.inserted_at}

    transactions = Repo.all(transactions_query_with_product)

    %{
      total_products_in_stock: total_products_in_stock,
      best_selling_product: best_selling_product,
      total_transactions: total_transactions,
      transactions: transactions
    }
  end
end

defmodule ClothingDashboardWeb.MyCalendar do
  @months ~w(January February March April May June July August September October November December)

  def month_name(month) when month in 1..12 do
    Enum.at(@months, month - 1)
  end
end
