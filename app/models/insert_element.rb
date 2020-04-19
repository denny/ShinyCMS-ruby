# frozen_string_literal: true

# Model class for Insert Elements (prev: 'shared content elements')
class InsertElement < ApplicationRecord
  include Element

  validates :set, presence: true

  belongs_to :set, class_name: 'InsertSet', inverse_of: 'elements'
end
