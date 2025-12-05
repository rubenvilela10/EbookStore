class FixOrdersTable < ActiveRecord::Migration[8.1]
  def change
    remove_column :orders, :ebook_id, :integer
    remove_column :orders, :price, :float
    remove_column :orders, :fee, :float

    add_column :orders, :total_price, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    add_column :orders, :total_fee,   :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
