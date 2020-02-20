# Model for feature flags
class FeatureFlag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  validates :enabled,               inclusion: { in: [ true, false ] }
  validates :enabled_for_logged_in, inclusion: { in: [ true, false ] }
  validates :enabled_for_admins,    inclusion: { in: [ true, false ] }

  # Class methods

  def self.update_all_flags( params )
    params['flags'].each_key do |flag_id|
      flag = find( flag_id )
      flag_params = params['flags'][flag_id]
      return false unless flag.update(
        enabled: flag_params['enabled'],
        enabled_for_logged_in: flag_params['enabled_for_logged_in'],
        enabled_for_admins: flag_params['enabled_for_admins']
      )
    end
    true
  end
end
