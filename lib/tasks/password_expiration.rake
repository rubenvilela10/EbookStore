namespace :security do
  desc "Force password updates every 6 months"
  task enforce_password_expiration: :environment do
    expired_users = User.where("password_changed_at IS NULL OR password_changed_at <= ?", 6.months.ago)

    expired_users.find_each do  |user|
      user.update_column(:password_expired, true)
      puts "Password expired for user #{user.id} - #{user.name}"
    end

    puts "Done. #{expired_users.count} users marked as expired."
  end
end
