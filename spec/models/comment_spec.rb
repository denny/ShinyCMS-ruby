# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_should_behave_like 'ShinyDemoDataProvider' do
    let( :model ) { Comment }
  end
end
