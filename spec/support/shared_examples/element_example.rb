# Shared test code, for testing the methods mixed-in by the Element concern
RSpec.shared_examples Element do
  context 'self.content_types' do
    it 'returns the list of possible content types' do
      types = element.content_types
      expect( types.size ).to eq 4
      expect( types      ).to include I18n.t 'short_text'
    end
  end
end
