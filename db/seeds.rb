# db/seeds.rb

puts "Starting seeds..."

# Seed default admin first
load Rails.root.join("db/seeds/admins.rb")

# Seed products only
load Rails.root.join("db/seeds/products.rb")

# Attach images (slow step)
load Rails.root.join("db/seeds/images.rb")

puts "✅ All seeds completed."
