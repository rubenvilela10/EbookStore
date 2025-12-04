class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order,        null: false, foreign_key: true
      t.references :ebook,        null: false, foreign_key: true
      t.float :price
      t.float :fee

      t.timestamps
    end
  end
end
