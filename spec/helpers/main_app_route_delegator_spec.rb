# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MainAppRouteDelegator, type: :helper do
  describe 'method_missing' do
    it 'fails correctly for a method which is missing from main app too' do
      skip 'Bad test is bad and it should feel bad'
      expect( ::Blazer::BaseController.respond_to_missing?( :b0rk ) ).to be false
    end
  end
end
