FactoryBot.define do
  factory :order_item do
    association :ebook
    association :order
    price { Faker::Commerce.price(range: 9.99..99.99) }
    fee { Faker::Commerce.price(range: 0.99..9.99) }
  end
end
