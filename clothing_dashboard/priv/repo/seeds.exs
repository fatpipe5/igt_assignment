# priv/repo/seeds.exs
alias ClothingDashboard.Repo
alias ClothingDashboard.Catalog.Product

# Let's insert some initial data:
products = [
  %{
    photo: "https://via.placeholder.com/150",
    title: "Classic T-Shirt",
    description: "A comfortable cotton t-shirt",
    category: "Tops",
    price: 19.99,
    stock: 50
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Blue Denim Jeans",
    description: "Stylish blue denim jeans with a snug fit",
    category: "Bottoms",
    price: 49.99,
    stock: 30
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Leather Jacket",
    description: "Genuine leather jacket for a biker look",
    category: "Outerwear",
    price: 129.99,
    stock: 10
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Sneakers",
    description: "Comfortable everyday sneakers",
    category: "Footwear",
    price: 59.99,
    stock: 20
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Sandals",
    description: "Open-toe sandals for summer",
    category: "Footwear",
    price: 29.99,
    stock: 40
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Maxi Dress",
    description: "Flowy maxi dress for special occasions",
    category: "Dresses",
    price: 79.99,
    stock: 15
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Hoodie",
    description: "Cozy hoodie for casual wear",
    category: "Tops",
    price: 39.99,
    stock: 25
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Beanie",
    description: "Warm beanie for cold weather",
    category: "Accessories",
    price: 14.99,
    stock: 60
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Flannel Shirt",
    description: "Classic flannel pattern shirt",
    category: "Tops",
    price: 34.99,
    stock: 35
  },
  %{
    photo: "https://via.placeholder.com/150",
    title: "Running Shorts",
    description: "Lightweight shorts for running",
    category: "Bottoms",
    price: 24.99,
    stock: 45
  }
]

Enum.each(products, fn product_data ->
  # Insert into database if not already existing (upsert approach).
  Repo.insert!(%Product{} |> Product.changeset(product_data))
end)

IO.puts("Seed data for products inserted successfully!")
