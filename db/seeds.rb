# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Only create a landing page if none exists
landing_page = LandingPage.first_or_create!(title: "Welcome", subtitle: "My Ebook Store", description: "This is a demo landing page", published: true)

# Create some landing sections
landing_page.landing_sections.create!(title: "Section 1", content: "Content for section 1")
landing_page.landing_sections.create!(title: "Section 2", content: "Content for section 2")

# Users
User.first_or_create!(name: "Admin", email: "admin@example.com", age: 30, address: "123 Admin St", country: "US", status: "enabled", role: "admin", password: "password")
seller = User.first_or_create!(name: "Seller", email: "seller@example.com", age: 28, address: "456 Seller St", country: "US", status: "enabled", role: "seller", password: "password")
User.first_or_create!(name: "Buyer", email: "buyer@example.com", age: 25, address: "789 Buyer St", country: "US", status: "enabled", role: "buyer", password: "password")

# Ebooks
3.times do |i|
  Ebook.first_or_create!(
    title: "Ebook #{i+1}",
    description: "Description for ebook #{i+1}",
    year: Time.zone.today - i.years,
    price: 9.99 + i,
    seller: seller
  )
end
