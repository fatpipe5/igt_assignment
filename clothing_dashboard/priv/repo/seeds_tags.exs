alias ClothingDashboard.Repo
alias ClothingDashboard.Catalog.{Product, Tag}

# Define some initial tags
tag_names = ["Sustainable", "Upcycled", "Thrifted", "Stylish", "Modern"]

# Insert tags into the database if they don't exist
Enum.each(tag_names, fn name ->
  Repo.insert!(
    %Tag{name: name},
    on_conflict: :nothing,
    conflict_target: :name
  )
end)

# Fetch all tags and products
tags = Repo.all(Tag)
products = Repo.all(Product)

# Associate random tags with each product
Enum.each(products, fn product ->
  product = Repo.preload(product, :tags) # Preload tags association

  random_tags = Enum.take_random(tags, Enum.random(1..3))

  product
  |> Ecto.Changeset.change()
  |> Ecto.Changeset.put_assoc(:tags, random_tags)
  |> Repo.update!()
end)

IO.puts("Seed data for tags and product-tag associations has been added.")
