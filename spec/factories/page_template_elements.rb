FactoryBot.define do
  factory :page_template_element do
    name { Faker::Science.unique.element }
  end
end
