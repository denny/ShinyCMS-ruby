# frozen_string_literal: true

module ShinyForms
  # Model for ShinyCMS form template elements
  class TemplateElement < ApplicationRecord
    include ShinyElement

    belongs_to :template
  end
end
