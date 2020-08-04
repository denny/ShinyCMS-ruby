# frozen_string_literal: true

# Shared test code, for testing the methods mixed-in by the ShinyElement concern
RSpec.shared_examples ShinyElement do
  context 'format_name' do
    it 'returns a valid element name' do
      # rubocop:disable Rails/SkipsModelValidations
      element.update_attribute( :name, 'Format Me Please!' )
      # rubocop:enable Rails/SkipsModelValidations
      element.format_name
      expect( element.name ).to eq 'format_me_please'
    end
  end
end
