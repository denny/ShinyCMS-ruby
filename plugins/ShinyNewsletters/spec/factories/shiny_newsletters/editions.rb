# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Edition model - ShinyNewsletters plugin for ShinyCMS
module ShinyNewsletters
  FactoryBot.define do
    factory :newsletter_edition, class: 'ShinyNewsletters::Edition' do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      subject { internal_name.dup }

      association :template, factory: :newsletter_template

      trait :with_content do
        after :build do |edition|
          edition.elements.each do |element|
            case element.element_type
            when 'short_text'
              element.update!( content: Faker::Books::CultureSeries.civs )
            when 'long_text'
              element.update!( content: Faker::Lorem.paragraph )
            when 'html'
              element.update!( content: "<p>#{Faker::Lorem.paragraph}</p>" )
            when 'image'
              test_file = Rails.root.join( 'app/assets/images/shinycms/spiral.png' )
              test_blob = ActiveStorage::Blob.create_after_upload!(
                io:           File.open( test_file ),
                filename:     'spiral.png',
                content_type: 'image/png'
              ).signed_id
              element.image.attach test_blob
            end
          end
        end
      end
    end
  end
end
