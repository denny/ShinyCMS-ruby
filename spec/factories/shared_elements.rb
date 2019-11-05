FactoryBot.define do
  factory :shared_element do
    name    { Faker::Science.unique.element }
    content { Faker::Science.scientist      }
    content_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
