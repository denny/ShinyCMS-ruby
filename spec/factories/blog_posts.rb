FactoryBot.define do
  factory :blog_post, class: 'BlogPost' do
    title  { 'Post Title' }
    slug   { 'post-slug'  }
    body   { 'Post body goes here...' }
    hidden { false        }
    posted_at { Time.zone.now }

    association :blog, factory: :blog
    association :user, factory: :user
  end
end
