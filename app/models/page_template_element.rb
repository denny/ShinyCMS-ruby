# Model class for template elements
class PageTemplateElement < ApplicationRecord
  include Element

  validates :template, presence: true

  belongs_to :template, class_name: 'PageTemplate', inverse_of: 'elements'
end
