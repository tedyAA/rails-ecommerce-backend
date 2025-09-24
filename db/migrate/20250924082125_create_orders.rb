class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.integer :total_cents
      t.string :status
      t.text :address
      t.string :payment_method

      t.timestamps
    end
  end
end
