class CreateEbookMetrics < ActiveRecord::Migration[8.1]
  def change
    create_table :ebook_metrics do |t|
      t.references :ebook,      null: false, foreign_key: true
      t.string :event_type
      t.string :ip
      t.string :user_agent
      t.text :extra_data

      t.timestamps
    end
  end
end
