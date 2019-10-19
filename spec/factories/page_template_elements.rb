FactoryBot.define do
  factory :page_template_element do
    name { Faker::Science.unique.element }
    content_type { I18n.t( 'short_text' ) }
  end
end
