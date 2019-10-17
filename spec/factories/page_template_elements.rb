FactoryBot.define do
  factory :page_template_element do
    name { FactoryBot::Science.unique.element }
  end
end
