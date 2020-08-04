# frozen_string_literal: true

# Shared test code, for testing methods and behaviour mixed-in by the ShinyName concern
RSpec.shared_examples ShinyName do
  describe '.name' do
    it 'returns the public_name if one is set' do
      named.public_name = Faker::Books::CultureSeries.unique.culture_ship

      expect( named.name ).not_to eq named.internal_name
      expect( named.name ).to     eq named.public_name
    end

    it 'returns the internal_name if public_name is not set' do
      named.public_name = nil

      expect( named.name ).not_to eq named.public_name
      expect( named.name ).to     eq named.internal_name
    end
  end
end
