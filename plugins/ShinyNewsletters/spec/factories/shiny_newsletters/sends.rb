# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for newsletter sends - ShinyNewsletters plugin for ShinyCMS
module ShinyNewsletters
  FactoryBot.define do
    factory :newsletter_send, class: 'ShinyNewsletters::Send' do
      association :edition, factory: :newsletter_edition
      association :list,    factory: :mailing_list
    end

    factory :newsletter_send_scheduled, parent: :newsletter_send do
      send_at { 2.hours.since }
    end

    factory :newsletter_send_sending, parent: :newsletter_send do
      started_sending_at { 3.hours.ago }
    end

    factory :newsletter_send_sent, parent: :newsletter_send_sending do
      finished_sending_at { 2.hours.ago }
    end
  end
end
