# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model for feature flags
  class FeatureFlag < ApplicationRecord
    include ShinyCMS::SoftDelete

    # Validations

    validates :name, presence: true, uniqueness: true

    validates :enabled,               inclusion: { in: [ true, false ] }
    validates :enabled_for_logged_in, inclusion: { in: [ true, false ] }
    validates :enabled_for_admins,    inclusion: { in: [ true, false ] }

    # Instance methods

    def enable
      update! enabled: true, enabled_for_logged_in: true, enabled_for_admins: true
    end

    alias on enable

    def disable
      update! enabled: false, enabled_for_logged_in: false, enabled_for_admins: false
    end

    alias off disable

    # Class methods

    def self.enabled?( name, user = nil )
      feature = find_by( name: name.to_s )

      return false if feature.blank?
      return true  if feature.enabled?

      return false if user.blank?
      return true  if feature.enabled_for_logged_in?

      return false unless user.admin?

      feature.enabled_for_admins?
    end

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
          enabled:               flag_params['enabled'],
          enabled_for_logged_in: flag_params['enabled_for_logged_in'],
          enabled_for_admins:    flag_params['enabled_for_admins']
        )
      end
      true
    end
  end
end
