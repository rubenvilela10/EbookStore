FactoryBot.define do
  factory :ebook_metric do
    association :ebook
    event_type { :view_pdf }
    extra_data { {} }
    ip { "127.0.0.1" }
    user_agent { "RSpec" }

    trait :view_pdf do
      event_type { :view_pdf }
    end

    trait :view_ebook do
      event_type { :view_ebook }
    end

    trait :purchase do
      event_type { :purchase }
    end
  end
end
