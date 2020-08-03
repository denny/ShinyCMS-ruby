# frozen_string_literal: true

module ShinyForms
  FactoryBot.define do
    factory :form, class: 'ShinyForms::Form', aliases: [ :plain_email_form ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      handler { 'plain_email' }
    end

    factory :template_email_form, class: 'ShinyForms::Form', parent: :form do
      handler { 'template_email' }
    end
  end
end
