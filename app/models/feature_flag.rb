# Model for feature flags
class FeatureFlag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # Class methods

  # Returns true if all valid, else false
  def self.update_all_flags( params )
    all_valid = true
    params['flags'].keys.map do |flag_id|
      flag = find( flag_id )
      flag_params = params['flags'][flag_id]
      valid = flag.update(
        enabled: flag_params['enabled'],
        enabled_for_logged_in: flag_params['enabled_for_logged_in'],
        enabled_for_admins: flag_params['enabled_for_admins']
      )
      all_valid = false if !valid
      flag
    end
    all_valid
  end
end
