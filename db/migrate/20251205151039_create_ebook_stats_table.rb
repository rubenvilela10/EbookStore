class CreateEbookStatsTable < ActiveRecord::Migration[8.1]
  def change
    create_table :ebook_stats do |t|
      t.references :ebook, null: false, index: { unique: true }
      t.integer :views_count, default: 0, null: false
      t.integer :purchases_count, default: 0, null: false
      t.integer :downloads_count, default: 0, null: false
      t.timestamps
    end
  end
end
