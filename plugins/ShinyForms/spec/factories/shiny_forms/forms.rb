# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for forms - ShinyForms plugin for ShinyCMS
module ShinyForms
  FactoryBot.define do
    factory :form, class: 'ShinyForms::Form', aliases: [ :plain_email_form ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      handler { 'send_plain_email' }
    end

    factory :template_email_form, class: 'ShinyForms::Form', parent: :form do
      handler  { 'send_html_email' }
      filename { 'contact_form'    }
    end
  end
end
