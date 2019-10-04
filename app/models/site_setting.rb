# Model class for site settings
class SiteSetting < ApplicationRecord
  def self.get( name )
    find_by( name: name )
  end
end
