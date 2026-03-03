# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ActiveSupport::Inflector.inflections( :en ) do |inflect|
  # Acronyms used in the ShinyCMS code
  inflect.acronym 'CMS'
  inflect.acronym 'IP'
  inflect.acronym 'HTML'
  inflect.acronym 'MJML'
  inflect.acronym 'PHP'
  inflect.acronym 'SEO'
  inflect.acronym 'ShinyCMS'
  inflect.acronym 'URL'

  # Some common acronyms that might be used in CMS content
  inflect.acronym 'AI'
  inflect.acronym 'API'
  inflect.acronym 'BBC'
  inflect.acronym 'CEO'
  inflect.acronym 'CPU'
  inflect.acronym 'CRM'
  inflect.acronym 'CTO'
  inflect.acronym 'EU'
  inflect.acronym 'PR'
  inflect.acronym 'REST'
  inflect.acronym 'RESTful'
  inflect.acronym 'UK'
  inflect.acronym 'USA'
  inflect.acronym 'USB'
  inflect.acronym 'VIP'
  inflect.acronym 'WWW'
end
