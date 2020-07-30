# frozen_string_literal: true

require 'rails_helper'

module ShinyForms
  RSpec.describe FormElement, type: :model do
    it_should_behave_like ShinyElement do
      let( :form    ) { create :form }
      let( :element ) { create :form_element, form: form }
    end
  end
end
