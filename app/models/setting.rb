# Model class for site settings
class Setting < ApplicationRecord
  validates :name, presence: true

  # Class methods

  # Return the value of the specified setting
  def self.get( name )
    where( name: name.to_s ).pick( :value )
  end
end
