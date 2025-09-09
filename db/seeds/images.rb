# db/seeds/attach_images.rb
file_path = Rails.root.join("db/seeds/full_seed.json")

if File.exist?(file_path)
  data = JSON.parse(File.read(file_path))

  data["products"].each do |prod_data|
    product = Product.find_by(
      name: prod_data["name"],
      category_id: prod_data["category_id"],
      type_id: prod_data["type_id"]
    )
    next unless product

    images_folder = Rails.root.join("db/seeds/images", prod_data["id"].to_s)
    next unless Dir.exist?(images_folder)

    Dir.glob("#{images_folder}/*").each do |img_path|
      filename = File.basename(img_path)
      next if product.images.attached? && product.images.map(&:filename).map(&:to_s).include?(filename)

      product.images.attach(
        io: File.open(img_path),
        filename: filename,
        content_type: "image/#{File.extname(img_path).delete('.')}"
      )
    end
  end

  puts "✅ Images attached."
else
  puts "No full_seed.json found."
end
