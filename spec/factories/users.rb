FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    age { 21 }
    role { :buyer }
    phone_number { "+351912345678" }
    sequence(:email) { |n| "user#{n}@email.com" }
    address { "street" }
    country { "PT" }
    status { :enabled }
    password { "123456" }

    trait :seller do
      role { :seller }
    end

    trait :buyer do
      role { :buyer }
      balance { 1000 }
    end

    trait :disabled do
      status { :disabled }
    end

    trait :enabled do
      status { :enabled }
    end
  end
end
