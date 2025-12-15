FactoryBot.define do
  factory :user do
    name { "John Doe" }
    role { "seller" }
    age { 21 }
    phone_number { "912345678" }
    sequence(:email) { |n| "johndoe#{n}@email.com" }
    address { "street" }
    country { "country" }
    status { "enabled" }
    password { "123456" }
  end
end
