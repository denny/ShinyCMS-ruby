FactoryBot.define do
  factory :shared_content_element do
    name    { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
    content { Faker::Science.unique.scientist }
    content_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
