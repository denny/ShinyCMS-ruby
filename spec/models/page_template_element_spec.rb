# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageTemplateElement, type: :model do
  it_should_behave_like ShinyElement do
    let( :template ) { create :page_template }
    let( :element  ) { create :page_template_element, template: template }
  end

  it_should_behave_like ShinyDemoDataProvider do
    let( :model ) { described_class }
  end
end
