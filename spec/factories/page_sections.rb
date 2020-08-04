# frozen_string_literal: true

FactoryBot.define do
  factory :page_section, aliases: [ :top_level_section ] do
    internal_name { Faker::Books::CultureSeries.unique.culture_ship }
    slug   { internal_name.dup.parameterize }

    trait :hidden do
      show_on_site { false }
    end
  end

  factory :page_subsection, parent: :page_section do
    association :section, factory: :page_section
  end
end
