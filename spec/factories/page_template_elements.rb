FactoryBot.define do
  factory :page_template_element do
    name { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
    content_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
