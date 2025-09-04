# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
file_path = Rails.root.join('db', 'full_seed.json')

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

  # Seed Products
  data["products"].each do |prod_data|
    Product.create!(
      name: prod_data["name"],
      description: prod_data["description"],
      price: prod_data["price"],
      category_id: category_mapping[prod_data["category_id"]],
      type_id: type_mapping[prod_data["type_id"]],
      active: prod_data["active"],
      bestseller: prod_data["bestseller"]
    )
  end

  puts "Seeded #{data['products'].size} products, #{data['categories'].size} categories, and #{data['types'].size} types."
else
  puts "No full_seed.json file found."
end
