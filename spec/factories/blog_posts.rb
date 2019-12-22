FactoryBot.define do
  factory :blog_post, class: 'BlogPost' do
    title  { Faker::Lorem.unique.sentence.titlecase }
    slug   { Faker::Lorem.unique.word.downcase  }
    body   { Faker::Lorem.paragraph }
    hidden { false }
    posted_at { Time.zone.now }

    association :blog, factory: :blog
    association :user, factory: :user
  end
end
