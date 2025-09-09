require "json"
require "fileutils"

puts "Exporting full seed..."

full_seed = {
  "categories" => [],
  "types" => [],
  "products" => []
}

# Export Categories
Category.find_each do |cat|
  full_seed["categories"] << {
    "id" => cat.id,
    "name" => cat.name,
    "description" => cat.description,
    "created_at" => cat.created_at,
    "updated_at" => cat.updated_at
  }
end

# Export Types
Type.find_each do |type|
  full_seed["types"] << {
    "id" => type.id,
    "name" => type.name,
    "description" => type.description,
    "created_at" => type.created_at,
    "updated_at" => type.updated_at
  }
end

# Export Products & Images
Product.find_each do |prod|
  full_seed["products"] << {
    "id" => prod.id,
    "name" => prod.name,
    "description" => prod.description,
    "price" => prod.price,
    "category_id" => prod.category_id,
    "type_id" => prod.type_id,
    "bestseller" => prod.bestseller,
    "created_at" => prod.created_at,
    "updated_at" => prod.updated_at
  }

  next unless prod.images.attached?

  prod_folder = Rails.root.join("db/seeds/images", prod.id.to_s)
  FileUtils.mkdir_p(prod_folder)

  prod.images.each do |image|
    blob = image.blob
    file_path = prod_folder.join(blob.filename.to_s)
    File.open(file_path, "wb") { |f| f.write(blob.download) }
  end
end

File.write(Rails.root.join("db/seeds/full_seed.json"), JSON.pretty_generate(full_seed))
puts "full_seed.json created at db/seeds/full_seed.json"
