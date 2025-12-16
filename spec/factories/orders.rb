FactoryBot.define do
  factory :order do
    association :buyer, factory: :user
    total_price { 10 }
    total_fee { 1 }
    destination_address { 'street' }
    billing_address { 'street' }
    payment_status { "paid" }
  end
end
