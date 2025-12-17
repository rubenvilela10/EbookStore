FactoryBot.define do
  factory :ebook do
    title { "The Bible" }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    price { Faker::Commerce.price(range: 9.99..99.99) }
    status { :draft }
    year { Date.new(2025, 1, 1) }
    author { "Jesus" }

    association :seller, factory: :user

    trait :draft do
      status { :draft }
    end

    trait :pending do
      status { :pending }
    end

    trait :live do
      status { :live }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 79.99..199.99) }
    end

    trait :with_pdf do
      after(:build) do |ebook|
        ebook.pdf_draft.attach(
          io: StringIO.new("dummy pdf content"),
          filename: "dummy.pdf",
          content_type: "application/pdf"
        )
      end
    end
  end
end
