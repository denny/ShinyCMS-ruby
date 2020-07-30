# frozen_string_literal: true

require 'rails_helper'

module ShinyForms
  RSpec.describe Form, type: :model do
    describe '.name' do
      it 'knows its own name' do
        name = Faker::Books::CultureSeries.unique.civs.parameterize

        form = create :form, name: name

        expect( form.name ).to eq name
      end
    end
  end
end
