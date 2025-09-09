# db/seeds/products_only.rb
file_path = Rails.root.join("db/seeds/full_seed.json")

if File.exist?(file_path)
  data = JSON.parse(File.read(file_path))

  # Seed Categories
  category_mapping = {}
  data["categories"].each do |cat_data|
    category = Category.find_or_create_by!(name: cat_data["name"])
    category_mapping[cat_data["id"]] = category.id
  end

  # Seed Types
  type_mapping = {}
  data["types"].each do |type_data|
    type = Type.find_or_create_by!(name: type_data["name"])
    type_mapping[type_data["id"]] = type.id
  end

  # Seed Products without images
  data["products"].each do |prod_data|
    Product.find_or_create_by!(
      name: prod_data["name"],
      category_id: category_mapping[prod_data["category_id"]],
      type_id: type_mapping[prod_data["type_id"]]
    ) do |product|
      product.description = prod_data["description"]
      product.price = prod_data["price"]
      product.bestseller = prod_data["bestseller"]
    end
  end

  puts "✅ Products seeded without images."
else
  puts "No full_seed.json found."
end
