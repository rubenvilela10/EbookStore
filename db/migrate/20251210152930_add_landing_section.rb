class AddLandingSection < ActiveRecord::Migration[8.1]
  def change
    create_table :landing_sections do |t|
      t.references :landing_page, null: false, foreign_key: true
      t.string :title
      t.string :subtitle
      t.text :content
      t.string :link
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
