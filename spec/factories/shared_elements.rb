FactoryBot.define do
  factory :shared_element do
    name  { Faker::Science.unique.element }
    type  { I18n.t( 'admin.elements.short_text' )        }
    value { Faker::Science.scientist      }
  end
end
