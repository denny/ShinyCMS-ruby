# frozen_string_literal: true

# Model class for template elements
class PageTemplateElement < ApplicationRecord
  include ShinyElement

  belongs_to :template, inverse_of: :elements, class_name: 'PageTemplate'

  validates :template, presence: true

  # Class methods

  def self.dump_for_demo?
    true
  end
end
