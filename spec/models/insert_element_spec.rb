# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsertElement, type: :model do
  it_should_behave_like ShinyElement do
    let( :set     ) { InsertSet.first }
    let( :element ) { create :insert_element, set: set }
  end

  it_should_behave_like ShinyDemoDataProvider do
    let( :model ) { described_class }
  end
end
