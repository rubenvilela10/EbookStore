FactoryBot.define do
  factory :ebook_metric do
    association :ebook
    event_type { "view_pdf" }
    extra_data { {} }
    ip { "127.0.0.1" }
    user_agent { "RSpec" }
  end
end
