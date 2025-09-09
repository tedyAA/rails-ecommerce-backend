file_path = Rails.root.join("db", "seeds/full_seed.json")

if File.exist?(file_path)
  data = JSON.parse(File.read(file_path))

  # Seed categories
  category_mapping = {}
  data["categories"].each do |cat_data|
    category = Category.find_or_create_by!(name: cat_data["name"])
    category_mapping[cat_data["id"]] = category.id
  end

  # Seed types
  type_mapping = {}
  data["types"].each do |type_data|
    type = Type.find_or_create_by!(name: type_data["name"])
    type_mapping[type_data["id"]] = type.id
  end

  # Seed products
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

    # Attach images
    images_folder = Rails.root.join("db/seeds/images", prod_data["id"].to_s)
    if Dir.exist?(images_folder)
      Dir.glob("#{images_folder}/*").each do |img_path|
        next if product.images.attached? && product.images.map(&:filename).map(&:to_s).include?(File.basename(img_path))
        product.images.attach(
          io: File.open(img_path),
          filename: File.basename(img_path),
          content_type: "image/#{File.extname(img_path).delete('.')}"
        )
      end
    end
  end

  puts "✅ Full seed completed: #{data['products'].size} products, #{data['categories'].size} categories, #{data['types'].size} types."
else
  puts "No full_seed.json found."
end
