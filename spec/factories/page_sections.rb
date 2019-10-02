FactoryBot.define do
  factory :page_section do
    name   { 'Test section' }
    title  { 'Test Section' }
    slug   { 'test-section' }
    hidden { false          }

    trait :hidden do
      hidden { true }
    end
  end

  factory :page_subsection, parent: :page_section do
    association :section, factory: :page_section
  end
end
