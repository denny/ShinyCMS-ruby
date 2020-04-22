# frozen_string_literal: true

FactoryBot.define do
  factory :page_template_element do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
    content_type { I18n.t( 'admin.elements.short_text' ) }
  end
end
