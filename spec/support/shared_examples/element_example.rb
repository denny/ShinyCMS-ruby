# Shared test code, for testing the methods mixed-in by the Element concern
RSpec.shared_examples Element do
  context 'format_name' do
    it 'returns a valid element name' do
      skip 'Not sure how to test this right now'
      # element.update_attribute name: 'Format Me Please' )
      element.format_name
      expect( element.name ).to eq 'format-me-please'
    end
  end
end
