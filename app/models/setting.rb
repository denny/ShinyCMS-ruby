# Model class for site settings
class Setting < ApplicationRecord
  def self.get( name )
    find_by( name: name )&.value
  end
end
