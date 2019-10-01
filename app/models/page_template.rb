# Model for page templates
class PageTemplate < ApplicationRecord
  # Associations
  has_many :pages, foreign_key: 'template_id', inverse_of: 'template',
                   dependent: :delete_all
end
