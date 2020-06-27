# frozen_string_literal: true

# Model class to group a set of Insert Elements (prev: 'shared content')
class InsertSet < ApplicationRecord
  has_many :elements, -> { order( :name ) },  inverse_of: :set,
                                              foreign_key: :set_id,
                                              class_name: 'InsertElement',
                                              dependent: :destroy

  accepts_nested_attributes_for :elements
end
