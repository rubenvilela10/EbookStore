FactoryBot.define do
  factory :order do
    association :buyer, factory: :user
    total_price { Faker::Commerce.price(range: 9.99..99.99) }
    total_fee { Faker::Commerce.price(range: 0.99..9.99) }
    destination_address { Faker::Address.full_address }
    billing_address { Faker::Address.full_address }
    payment_status { :paid }

    trait :paid do
      payment_status { :payd }
    end

    trait :cancelled do
      payment_status { :cancelled }
    end
  end
end
