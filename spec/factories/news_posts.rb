FactoryBot.define do
  factory :news_post, class: 'NewsPost' do
    title  { Faker::Science.unique.scientist.titlecase }
    slug   { title.dup.parameterize }
    body   { Faker::Lorem.paragraph }
    hidden { false }
    posted_at { Time.zone.now }

    association :author, factory: :user
  end
end
