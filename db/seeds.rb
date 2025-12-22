# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


return if LandingPage.exists?


landing_page = LandingPage.create!(
  title: "Ebook Store",
  subtitle: "Learn, Read, Grow",
  description: "A modern platform to buy and sell high-quality ebooks.",
  published: true
)

LandingSection.create!([
  {
    landing_page: landing_page,
    title: "Discover New Ebooks",
    content: "Browse a curated collection of high-quality ebooks from various authors.",
    position: 1
  },
  {
    landing_page: landing_page,
    title: "Sell Your Knowledge",
    content: "Publish and sell your own ebooks with ease.",
    position: 2
  },
  {
    landing_page: landing_page,
    title: "Secure Payments",
    content: "Safe and reliable transactions for buyers and sellers.",
    position: 3
  }
])


User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "Admin User"
  user.password = "password"
  user.role = "admin"
  user.age = 30
  user.address = "123 Admin St"
  user.country = "USA"
  user.status = "enabled"
end

seller = User.find_or_create_by!(email: "seller@example.com") do |user|
  user.name = "Seller User"
  user.password = "password"
  user.role = "seller"
  user.age = 28
  user.address = "456 Seller Rd"
  user.country = "USA"
  user.status = "enabled"
end

User.find_or_create_by!(email: "buyer@example.com") do |user|
  user.name = "Buyer User"
  user.password = "password"
  user.role = "buyer"
  user.age = 25
  user.address = "789 Buyer Ave"
  user.country = "USA"
  user.status = "enabled"
end


Ebook.find_or_create_by!(title: "Ruby on Rails Guide") do |ebook|
  ebook.author = "Jane Doe"
  ebook.price = 19.99
  ebook.seller = seller
  ebook.status = "live"
  ebook.year = Date.new(2025, 1, 1)
  ebook.description = "A comprehensive guide to learning Ruby on Rails."
end

Ebook.find_or_create_by!(title: "Mastering Docker") do |ebook|
  ebook.author = "John Smith"
  ebook.price = 29.99
  ebook.seller = seller
  ebook.status = "live"
  ebook.year = Date.new(2025, 2, 1)
  ebook.description = "Everything you need to know to master Docker for development and deployment."
end

Ebook.find_or_create_by!(title: "Learning PostgreSQL") do |ebook|
  ebook.author = "Alice Johnson"
  ebook.price = 14.99
  ebook.seller = seller
  ebook.status = "live"
  ebook.year = Date.new(2025, 3, 1)
  ebook.description = "Learn PostgreSQL from scratch and become a database expert."
end
