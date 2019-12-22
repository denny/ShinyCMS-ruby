FactoryBot.define do
  factory :page_template do
    name { Faker::Lorem.unique.word }
    filename { 'an_example' }
  end
end
