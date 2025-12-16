FactoryBot.define do
  factory :ebook_metric do
     { event_type: "view_pdf" }
     { ip: "8.8.8.8" }
     { extra_data: "" }

     association :ebook, factory: :ebook
  end
end
