# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Form model
module ShinyForms
  RSpec.describe Form, type: :model do
    context 'instance methods' do
      describe '.name' do
        it 'knows its own name' do
          ship_name = Faker::Books::CultureSeries.unique.civs.parameterize

          form = create :form, internal_name: ship_name

          expect( form.name ).to eq ship_name
        end
      end
    end

    context 'concerns' do
      it_should_behave_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end
    end
  end
end
