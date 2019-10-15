FactoryBot.define do
  factory :page, aliases: [ :top_level_page ] do
    name   { Faker::Science.unique.element }
    title  { name.dup.titlecase }
    slug   { name.dup.downcase.gsub( /\s+/, '-' ) }
    hidden { false }
    association :template, factory: :page_template

    trait :hidden do
      hidden { true }
    end
  end

  factory :page_in_section, parent: :page do
    association :section, factory: :page_section
  end

  factory :page_in_subsection, parent: :page do
    association :section, factory: :page_subsection
  end
end
