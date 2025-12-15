FactoryBot.define do
  factory :order_item do
    association :ebook
    association :order
    price { 10 }
    fee { 1 }
  end
end
