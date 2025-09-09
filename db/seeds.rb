# db/seeds.rb

puts "Starting seeds..."

# Seed products only
load Rails.root.join("db/seeds/products.rb")

# Seed images separately
load Rails.root.join("db/seeds/images.rb")

# Seed default admin
load Rails.root.join("db/seeds/admins.rb")

puts "✅ All seeds completed."
