# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.inflections( :en ) do |inflect|
  # Acronyms used in the CMS code
  inflect.acronym 'IP'
  inflect.acronym 'HTML'
  inflect.acronym 'MJML'

  # Some common acronyms that might be used in CMS content (and then b0rked by .titlecase)
  inflect.acronym 'AI'
  inflect.acronym 'API'
  inflect.acronym 'BBC'
  inflect.acronym 'CEO'
  inflect.acronym 'CMS'
  inflect.acronym 'CPU'
  inflect.acronym 'CRM'
  inflect.acronym 'CTO'
  inflect.acronym 'EU'
  inflect.acronym 'PR'
  inflect.acronym 'UK'
  inflect.acronym 'USA'
  inflect.acronym 'USB'
  inflect.acronym 'VIP'
  inflect.acronym 'WWW'
end
