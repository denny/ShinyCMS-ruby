# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Edition model - ShinyNewsletters plugin for ShinyCMS
module ShinyNewsletters
  FactoryBot.define do
    factory :newsletter_edition, class: 'ShinyNewsletters::Edition' do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      subject { internal_name.dup }

      association :template, factory: :newsletter_template

      after :create do |edition|
        edition.elements.each do |element|
          if element.element_type == 'image'
            element.update!( content: 'ShinyCMS-logo.png' )
          else
            element.update!( content: Faker::Books::CultureSeries.civs )
          end
        end
      end
    end
  end
end
