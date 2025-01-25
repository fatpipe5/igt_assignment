alias ClothingDashboard.Repo
alias ClothingDashboard.Catalog.{Product, Transaction}

products = Repo.all(Product)

Enum.each(1..10, fn _ ->
  product = Enum.random(products)

  # Generate a random NaiveDateTime for 2025
  random_date =
    ~N[2025-01-01 00:00:00]
    |> NaiveDateTime.add(Enum.random(0..364) * 24 * 60 * 60, :second) # Add random days in seconds

  Repo.insert!(%Transaction{
    product_id: product.id,
    quantity: Enum.random(1..5),
    inserted_at: random_date,
    updated_at: random_date
  })
end)
