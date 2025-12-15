FactoryBot.define do
  factory :order do
    association :buyer, factory: :user
    total_price { 10 }
    total_fee { 1 }
  end
end
