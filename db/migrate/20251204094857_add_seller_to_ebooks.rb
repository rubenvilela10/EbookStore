class AddSellerToEbooks < ActiveRecord::Migration[8.1]
  def change
    add_reference :ebooks, :seller, null: false, foreign_key: { to_table: :users } # rubocop:disable Rails/NotNullColumn
  end
end
