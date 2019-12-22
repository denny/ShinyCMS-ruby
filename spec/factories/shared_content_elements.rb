FactoryBot.define do
  factory :shared_content_element do
    name    { Faker::Lorem.unique.word.downcase }
    content { Faker::Lorem.unique.sentence }
    content_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
