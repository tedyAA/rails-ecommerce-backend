class AddBestsellerToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :bestseller, :boolean, default: false
  end
end
