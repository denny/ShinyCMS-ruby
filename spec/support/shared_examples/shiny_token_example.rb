# frozen_string_literal: true

# Shared test code, for testing methods mixed-in by the ShinyToken concern
RSpec.shared_examples ShinyToken do
  context 'generation' do
    it 'generates a token when saved, if none is present' do
      tokenised.token = nil
      expect( tokenised.token ).to be_blank

      tokenised.save!
      expect( tokenised.token ).to match %r{[-\w]+}
    end
  end
end
