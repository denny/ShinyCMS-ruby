# Model class to group a set of Insert Elements (prev: 'shared content')
class InsertSet < ApplicationRecord
  has_many :elements, -> { order( :name ) },
           class_name: 'InsertElement',
           foreign_key: 'set_id',
           inverse_of: 'set',
           dependent: :destroy

  accepts_nested_attributes_for :elements
end
