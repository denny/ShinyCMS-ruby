# frozen_string_literal: true

# Shared test code, for testing methods mixed-in by ShinyDemoDataProvider concern
RSpec.shared_examples ShinyDemoDataProvider do
  describe '.dump_for_demo?' do
    it 'returns true' do
      expect( model.dump_for_demo? ).to be true
    end
  end
end
