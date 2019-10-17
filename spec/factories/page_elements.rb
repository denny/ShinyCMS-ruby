FactoryBot.define do
  factory :page_element do
    name { Faker::Science.unique.element }
  end
end
