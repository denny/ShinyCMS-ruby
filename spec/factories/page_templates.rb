FactoryBot.define do
  factory :page_template do
    name { Faker::Science.unique.scientist }
    filename { 'an_example' }
  end
end
