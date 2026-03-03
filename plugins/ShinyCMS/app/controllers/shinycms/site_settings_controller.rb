# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for user-site-settings features on a ShinyCMS site
  class SiteSettingsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :authenticate_user!

    def index
      @settings =
        if current_user_is_admin?
          Setting.readonly.admin_settings
        else
          Setting.readonly.user_settings
        end
    end

    def update
      all_updated = update_settings( settings_params )
      if all_updated.nil?
        flash[ :notice ] = t( '.unchanged' )
      elsif all_updated
        flash[ :notice ] = t( '.success' )
      end
      redirect_to site_settings_path
    end

    private

    def update_settings( params )
      flags = initialise_flags
      params&.each_key do |key|
        next unless /value_(?<id>\d+)/ =~ key

        flag  = update_value( id, params )
        flags = update_flags( flag, flags )
      end
      return if flags[ :no_change ]

      flags[ :no_errors ]
    end

    def update_value( id, params )
      setting = Setting.find( id )

      return false if setting.level == 'site'
      return false if setting.level == 'admin' && current_user_is_not_admin?

      value = setting.values.find_or_initialize_by( user_id: current_user.id )
      value_param = params[ "value_#{id}" ] || ''

      _ret = value.update( value: value_param ) unless value.value == value_param
    end

    def initialise_flags
      flags = {}
      flags[ :no_change ] = true
      flags[ :no_errors ] = true
      flags
    end

    def update_flags( flag, flags )
      flags[ :no_change ] = false unless flag.nil?
      flags[ :no_errors ] = false if flag == false
      flags
    end

    def settings_params
      params.permit(
        :authenticity_token, :commit, :_method, settings: {}
      )[ :settings ]
    end
  end
end
