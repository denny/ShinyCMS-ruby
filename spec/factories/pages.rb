FactoryBot.define do
  factory :page do
    name     { 'Test page' }
    title    { 'Test Page' }
    slug     { 'test-page' }
    hidden   { false       }
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
