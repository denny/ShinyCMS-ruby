FactoryBot.define do
  factory :page_template_element do
    name { Faker::Lorem.unique.word }
    content_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
