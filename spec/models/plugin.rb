# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plugin, type: :model do
  describe '.loaded' do
    it 'returns a list of plugin names' do
      expect( Plugin.loaded ).to be_an Array
    end
  end
end
