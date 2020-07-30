# frozen_string_literal: true

module ShinyForms
  # Model for ShinyCMS form elements
  class FormElement < ApplicationRecord
    include ShinyElement

    belongs_to :form
  end
end
