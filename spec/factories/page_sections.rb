FactoryBot.define do
  factory :page_section do
    name   { Faker::Space.galaxy }
    title  { Faker::Space.nebula }
    slug   { Faker::Science.unique.element.downcase }
    hidden { false }

    trait :hidden do
      hidden { true }
    end
  end

  factory :page_subsection, parent: :page_section do
    association :section, factory: :page_section
  end
end
