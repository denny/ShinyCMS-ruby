FactoryBot.define do
  factory :shared_element do
    name  { Faker::Science.unique.element }
    type  { I18n.t( 'short_text' )        }
    value { Faker::Science.scientist      }
  end
end
