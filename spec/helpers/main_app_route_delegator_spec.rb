# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MainAppRouteDelegator, type: :helper do
  describe 'method_missing' do
    it 'fails correctly for a method which is missing from main app too' do
      expect { ::Blazer::BaseController.new.render( inline: '<%= w0rks? %>' ) }
        .to raise_error ActionView::Template::Error
    end
  end
end
