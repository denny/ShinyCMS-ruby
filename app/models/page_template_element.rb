# frozen_string_literal: true

# Model class for template elements
class PageTemplateElement < ApplicationRecord
  include Element

  belongs_to :template, inverse_of: :elements, class_name: 'PageTemplate'

  validates :template, presence: true
end
