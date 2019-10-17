# Model class for template elements
class PageTemplateElement < ApplicationRecord
  validates :name, presence: true

  belongs_to :template, class_name: 'PageTemplate', inverse_of: 'elements'
end
