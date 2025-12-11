class AddLandingPage < ActiveRecord::Migration[8.1]
  def change
    create_table :landing_pages do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
