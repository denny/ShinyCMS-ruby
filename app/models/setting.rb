# Model class for site settings
class Setting < ApplicationRecord
  # Class methods

  # Return the value of the specified setting
  def self.get( name )
    where( name: name).pick( :value )
  end
end
