class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :buyer,              null: false, foreign_key: {to_table: :users }
      t.references :ebook,              null: false, foreign_key: true
      t.float :price,                   null: false, default: 0.0
      t.float :fee,                     null: false, default: 0.0
      t.string :destination_address
      t.string :billing_address
      t.string :payment_status,         null: false, default: "N/A"

      t.timestamps
    end
  end
end
