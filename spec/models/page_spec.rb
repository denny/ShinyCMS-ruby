require 'rails_helper'

RSpec.describe Page, type: :model do
  context '.are_there_any_hidden_pages?' do
    it 'it correctly says yep' do
      create :page, :hidden
      expect( Page.are_there_any_hidden_pages? ).to eq true
    end
    it 'it correctly says nope' do
      create :page
      expect( Page.are_there_any_hidden_pages? ).to eq false
    end
  end
end
