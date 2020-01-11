require 'rails_helper'

RSpec.describe InsertElement, type: :model do
  it_should_behave_like Element do
    let( :set     ) { InsertSet.first }
    let( :element ) { create :insert_element, set: set }
  end
end
