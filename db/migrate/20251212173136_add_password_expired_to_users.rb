class AddPasswordExpiredToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_expired, :boolean
  end
end
