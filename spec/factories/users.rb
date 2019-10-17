FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    email    { Faker::Internet.unique.email    }
    password { Faker::Internet.password        }
  end
end
