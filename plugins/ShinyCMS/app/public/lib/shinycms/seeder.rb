# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for setting common types of seed data for ShinyCMS plugins
  class Seeder
    def seed_consent_version( name:, slug:, display_text: nil, admin_notes: nil )
      ShinyCMS::ConsentVersion.find_or_create_by!(
        name:         name,
        slug:         slug,
        display_text: display_text,
        admin_notes:  admin_notes
      )
    end

    def seed_feature_flag( name:, description: nil, enabled: true )
      flag = ShinyCMS::FeatureFlag.find_or_create_by!( name: name.to_s )
      flag.update!(
        description:           description,
        enabled:               enabled,
        enabled_for_logged_in: enabled,
        enabled_for_admins:    enabled
      )
      flag
    end

    def seed_setting( name:, value: '', description: nil, level: 'site', locked: false )
      setting = ShinyCMS::Setting.find_or_create_by!( name: name.to_s )
      setting.unlock

      setting.update!( description: description ) if description.present?
      setting.update!( level: level ) unless setting.level == level

      setting_value = setting.values.find_or_create_by!( user: nil )

      setting_value.update!( value: value ) unless ShinyCMS::Setting.get( name ) == value

      setting.lock if locked
      setting
    end

    def seed_standard_admin_capabilities( category: )
      cc = ShinyCMS::CapabilityCategory.find_or_create_by!( name: category.to_s )
      cc.capabilities.find_or_create_by!( name: 'list'    )
      cc.capabilities.find_or_create_by!( name: 'add'     )
      cc.capabilities.find_or_create_by!( name: 'edit'    )
      cc.capabilities.find_or_create_by!( name: 'destroy' )
      cc
    end
  end
end
