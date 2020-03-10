FactoryBot.define do
  factory :page_template do
    name     { Faker::Books::CultureSeries.unique.culture_ship }
    filename { 'an_example' }
  end
end
