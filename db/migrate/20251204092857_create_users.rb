class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name,         null: false
      t.string :role,         null: false
      t.string :age
      t.string :phone_number, null: false
      t.string :email,        null: false
      t.string :address
      t.string :country
      t.string :status,       null: false, default: "enabled"

      t.timestamps
    end
  end
end
