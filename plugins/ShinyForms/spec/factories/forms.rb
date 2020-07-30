# frozen_string_literal: true

module ShinyForms
  FactoryBot.define do
    factory :form, class: 'ShinyForms::Form' do
      name { Faker::Books::CultureSeries.unique.culture_ship }
      internal_name  { name.dup.titlecase }
      slug { name.dup.parameterize }
      association :template, factory: :template

      trait :hidden do
        show_on_site { false }
      end
    end
  end
end
