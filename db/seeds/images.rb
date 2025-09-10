file_path = Rails.root.join("db/seeds/full_seed.json")

if File.exist?(file_path)
  data = JSON.parse(File.read(file_path))
  product_data = data["products"].index_by { |p| p["id"] }

  Product.where(id: product_data.keys).find_in_batches(batch_size: 5) do |batch|
    batch.each do |product|
      prod_data = product_data[product.id]
      next unless prod_data

      images_folder = Rails.root.join("db/seeds/images", prod_data["id"].to_s)
      next unless Dir.exist?(images_folder)

      Dir.glob("#{images_folder}/*").each do |img_path|
        filename = File.basename(img_path)

        # Skip if already attached
        next if product.images.attached? &&
                product.images.any? { |img| img.filename.to_s == filename }

        File.open(img_path) do |file|
          product.images.attach(
            io: file,
            filename: filename,
            content_type: "image/#{File.extname(img_path).delete('.')}"
          )
        end
      end
    end
  end

  puts "✅ Images attached."
else
  puts "❌ No full_seed.json found."
end
