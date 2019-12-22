FactoryBot.define do
  factory :blog_post, class: 'BlogPost' do
    title  { Faker::Science.unique.scientist.titlecase }
    slug   { title.dup.downcase.gsub( /[^\w\s]/, '' ).gsub( /\s+/, '-' ) }
    body   { Faker::Lorem.paragraph }
    hidden { false }
    posted_at { Time.zone.now }

    association :blog, factory: :blog
    association :user, factory: :user
  end
end
