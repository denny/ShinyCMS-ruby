FactoryBot.define do
  factory :page_element do
    name { FactoryBot::Science.unique.element }
  end
end
