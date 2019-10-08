FactoryBot.define do
  factory :page do
    name     { Faker::Space.galaxy }
    title    { Faker::Space.nebula }
    slug     { Faker::Science.unique.element.downcase }
    hidden   { false }
    association :template, factory: :page_template

    trait :hidden do
      hidden { true }
    end
  end

  factory :top_level_page, parent: :page do
  end

  factory :page_in_section, parent: :page do
    association :section, factory: :page_section
  end

  factory :page_in_subsection, parent: :page do
    association :section, factory: :page_subsection
  end
end
