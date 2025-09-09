file_path = Rails.root.join("db/seeds/full_seed.json")

if File.exist?(file_path)
  data = JSON.parse(File.read(file_path))

  # Preload products in a hash if needed
  products_map = Product.where(id: data["products"].map { |p| p["id"] }).index_by(&:id)

  # Process products in batches of 5 to avoid SQLite locking
  Product.find_in_batches(batch_size: 5) do |batch|
    batch.each do |product|
      prod_data = data["products"].find { |p| p["id"] == product.id }
      next unless prod_data

      images_folder = Rails.root.join("db/seeds/images", prod_data["id"].to_s)
      next unless Dir.exist?(images_folder)

      attachments = Dir.glob("#{images_folder}/*").map do |img_path|
        { io: File.open(img_path),
          filename: File.basename(img_path),
          content_type: "image/#{File.extname(img_path).delete('.')}" }
      end

      product.images.attach(attachments) unless attachments.empty?
    end
  end

  puts "✅ Images attached."
else
  puts "No full_seed.json found."
end
