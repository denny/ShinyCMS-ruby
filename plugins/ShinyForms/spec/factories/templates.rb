# frozen_string_literal: true

FactoryBot.define do
  factory :template, class: 'ShinyForms::Template' do
    name     { Faker::Books::CultureSeries.unique.culture_ship }
    filename { 'a_form' }
  end
end
