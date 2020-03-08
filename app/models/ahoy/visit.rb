# Model for tracking website visits using ahoy
class Ahoy::Visit < ApplicationRecord
  self.table_name = 'ahoy_visits'

  has_many :events, class_name: 'Ahoy::Event', dependent: :reject_with_error
  belongs_to :user, optional: true
end
