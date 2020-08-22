# frozen_string_literal: true

module ShinyPages
  # Model class for template elements
  class TemplateElement < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyElement

    belongs_to :template, inverse_of: :elements

    validates :template, presence: true

    def self.capability_category_name
      'page_templates'
    end
  end
end
