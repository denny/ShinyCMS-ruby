FactoryBot.define do
  factory :blog do
    name   { 'Blog name'  }
    title  { 'Blog Title' }
    slug   { 'slug'       }

    hidden_from_menu { false }
    hidden { false }

    association :user, factory: :user
  end
end
