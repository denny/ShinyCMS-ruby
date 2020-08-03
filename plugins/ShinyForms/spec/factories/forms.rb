# frozen_string_literal: true

module ShinyForms
  FactoryBot.define do
    factory :form, class: 'ShinyForms::Form', aliases: [ :plain_text_email_form ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      slug { name.dup.parameterize }
      handler { 'plain_text_email' }
    end

    factory :mjml_template_email_form, class: 'ShinyForms::Form' do
      handler { 'mjml_template_email' }
      filename { 'contact-form' }
    end
  end
end
