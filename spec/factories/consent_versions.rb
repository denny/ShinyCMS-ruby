# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Consent model (holds details of things users can agree to, e.g. 'subscribe to mailing list')
FactoryBot.define do
  factory :consent_version do
    name { 'Newsletter (3rd September 2020)' }
    slug { 'newsletter-2020-09-03' }
    full_text { 'Your ideas are intriguing to me and I wish to subscribe to your newsletter.' }
  end
end
