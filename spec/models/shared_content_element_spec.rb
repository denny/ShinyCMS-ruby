require 'rails_helper'

RSpec.describe SharedContentElement, type: :model do
  it_should_behave_like Element do
    let( :element ) { create :shared_content_element }
  end
end
