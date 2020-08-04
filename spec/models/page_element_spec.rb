# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageElement, type: :model do
  it_should_behave_like ShinyElement do
    let( :page    ) { create :page }
    let( :element ) { create :page_element, page: page }
  end
end
