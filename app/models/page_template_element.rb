# Model class for template elements
class PageTemplateElement < ApplicationRecord
  validates :name, presence: true
  validates :template, presence: true

  belongs_to :template, class_name: 'PageTemplate', inverse_of: 'elements'

  # Class methods

  def self.element_types
    [
      I18n.t( 'short_text' ),
      I18n.t( 'long_text'  ),
      I18n.t( 'filename'   ),
      I18n.t( 'html'       )
    ]
  end
end
