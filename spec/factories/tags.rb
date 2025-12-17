FactoryBot.define do
  factory :tag do
    name { Faker::Name.name }
    association :ebook
  end
end
