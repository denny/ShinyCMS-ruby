# frozen_string_literal: true

module ShinyForms
  # Model for ShinyCMS forms
  class Form < ApplicationRecord
    belongs_to :template
  end
end
