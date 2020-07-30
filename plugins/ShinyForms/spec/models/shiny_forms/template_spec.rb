# frozen_string_literal: true

require 'rails_helper'

module ShinyForms
  RSpec.describe Template, type: :model do
    describe '.name' do
      it 'knows its own name' do
        name = Faker::Books::CultureSeries.unique.civs.parameterize

        template = create :form, name: name

        expect( template.name ).to eq name
      end
    end
  end
end
