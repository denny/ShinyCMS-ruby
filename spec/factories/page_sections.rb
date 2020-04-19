# frozen_string_literal: true

FactoryBot.define do
  factory :page_section, aliases: [ :top_level_section ] do
    name   { Faker::Books::CultureSeries.unique.culture_ship }
    title  { name.dup.titlecase    }
    slug   { name.dup.parameterize }
    hidden { false }

    trait :hidden do
      hidden { true }
    end
  end

  factory :page_subsection, parent: :page_section do
    association :section, factory: :page_section
  end
end
