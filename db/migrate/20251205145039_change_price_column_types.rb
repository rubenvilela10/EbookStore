class ChangePriceColumnTypes < ActiveRecord::Migration[8.1]
  def change
    change_column :order_items, :price, :decimal, precision: 10, scale: 2, null: false, default: 0.0
    change_column :order_items, :fee, :decimal, precision: 10, scale: 2, null: false, default: 0.0

    change_column :ebooks, :price, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end
