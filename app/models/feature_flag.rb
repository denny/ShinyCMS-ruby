# frozen_string_literal: true

# Model for feature flags
class FeatureFlag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  validates :enabled,               inclusion: { in: [ true, false ] }
  validates :enabled_for_logged_in, inclusion: { in: [ true, false ] }
  validates :enabled_for_admins,    inclusion: { in: [ true, false ] }

  # Instance methods

  def enable
    update! enabled: true, enabled_for_logged_in: true, enabled_for_admins: true
  end

  def disable
    update! enabled: false, enabled_for_logged_in: false,
            enabled_for_admins: false
  end

  # Class methods

  def self.enable( name )
    flag = find_by!( name: name.to_s )
    flag.enable
    flag
  end

  def self.disable( name )
    flag = find_by!( name: name.to_s )
    flag.disable
    flag
  end

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
