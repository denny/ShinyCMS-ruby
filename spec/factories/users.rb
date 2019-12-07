FactoryBot.define do
  factory :user do
    username     { Faker::Internet.unique.username }
    email        { Faker::Internet.unique.email    }
    password     { Faker::Internet.password        }
    confirmed_at { Time.current                    }
  end

  factory :admin_user, parent: :user do
    after :create do |admin|
      cape = create :capability, name: I18n.t( 'capability.view_admin_area' )
      create :user_capability, user_id: admin.id, capability_id: cape.id
    end
  end
end
