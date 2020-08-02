# frozen_string_literal: true

FactoryBot.define do
  factory :insert_element do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
    element_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
