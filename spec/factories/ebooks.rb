FactoryBot.define do
  factory :ebook do
    title { "The Bible" }
    description { "The Bible is a collection of religious texts that are central to Christianity and Judaism, and esteemed in other Abrahamic religions such as Islam. The Bible is an anthology originally written in Hebrew and Koine Greek. The texts include instructions, stories, poetry, prophecies, and other genres." }
    price { 19.90 }
    status { "live" }
    year { "2025-12-15 11:15:48" }
    author { "Jesus" }

    association :seller, factory: :user
  end
end
