# Model class for page elements
class PageElement < ApplicationRecord
  include Element

  validates :page, presence: true

  belongs_to :page, inverse_of: 'elements'
end
