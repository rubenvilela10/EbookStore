class CreateEbooks < ActiveRecord::Migration[8.1]
  def change
    create_table :ebooks do |t|
      t.string  :title,       null: false
      t.text    :description
      t.float   :price,       null: false, default: 0.0
      t.integer :quantity,    null: false, default: 0
      t.string  :status,      null: false, default: "draft"
      t.string  :author,      null: false
      t.date    :year,        null: false

      t.timestamps
    end
  end
end
