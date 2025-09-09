# db/seeds.rb
require "json"

file_path = Rails.root.join("db", "full_seed.json")

unless File.exist?(file_path)
  puts "⚠️  No full_seed.json file found."
  exit
end

data = JSON.parse(File.read(file_path))

puts "Seeding categories..."
category_mapping = {}
data["categories"].each do |cat_data|
  category = Category.find_or_create_by!(name: cat_data["name"]) do |c|
    c.description = cat_data["description"]
  end
  category_mapping[cat_data["id"]] = category.id
end

puts "Seeding types..."
type_mapping = {}
data["types"].each do |type_data|
  type = Type.find_or_create_by!(name: type_data["name"]) do |t|
    t.description = type_data["description"]
  end
  type_mapping[type_data["id"]] = type.id
end

puts "Seeding products..."
data["products"].each do |prod_data|
  product = Product.find_or_initialize_by(
    name: prod_data["name"],
    category_id: category_mapping[prod_data["category_id"]],
    type_id: type_mapping[prod_data["type_id"]]
  )
  product.assign_attributes(
    description: prod_data["description"],
    price: prod_data["price"],
    bestseller: prod_data["bestseller"]
  )
  product.save!

  # Attach images if folder exists
  images_folder = Rails.root.join("db", "seeds", "images", prod_data["id"].to_s)
  if Dir.exist?(images_folder)
    Dir.glob("#{images_folder}/*").each do |img_path|
      next if product.images.attached? && product.images.map(&:filename).map(&:to_s).include?(File.basename(img_path))
      product.images.attach(
        io: File.open(img_path),
        filename: File.basename(img_path),
        content_type: "image/#{File.extname(img_path).delete('.')}"
      )
    end
  else
    puts "⚠️  No images found for product '#{prod_data["name"]}' (ID: #{prod_data["id"]})"
  end
end

puts "✅ Seeded #{data['products'].size} products, #{data['categories'].size} categories, and #{data['types'].size} types."
