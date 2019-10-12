FactoryBot.define do
  factory :page_template do
    name     { Faker::DcComics.unique.villain }
    filename { 'example' }
  end
end
