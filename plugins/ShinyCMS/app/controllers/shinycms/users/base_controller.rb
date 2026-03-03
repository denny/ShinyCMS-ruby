# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # ShinyCMS base controller for Devise to inherit from
  class Users::BaseController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :configure_permitted_parameters, if: :devise_controller?

    # Strong params config for Devise
    SIGN_UP_PARAMS = %i[ username email password password_confirmation ].freeze
    SIGN_IN_PARAMS = %i[ username email password password_confirmation login remember_me ].freeze
    # rubocop:disable Layout/MultilineArrayLineBreaks
    ACCOUNT_UPDATE_PARAMS = %i[
      username email password password_confirmation current_password
      display_name display_email profile_pic bio website location postcode
    ].freeze
    # rubocop:enable Layout/MultilineArrayLineBreaks
    private_constant :SIGN_UP_PARAMS
    private_constant :SIGN_IN_PARAMS
    private_constant :ACCOUNT_UPDATE_PARAMS

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit( :sign_up ) do |user_params|
        user_params.permit( SIGN_UP_PARAMS )
      end

      devise_parameter_sanitizer.permit( :sign_in ) do |user_params|
        user_params.permit( SIGN_IN_PARAMS )
      end

      devise_parameter_sanitizer.permit( :account_update ) do |user_params|
        user_params.permit( ACCOUNT_UPDATE_PARAMS )
      end
    end

    def after_sign_in_path_for( resource )
      check_for_pwnage( resource )

      stored_location_for( :user ) || main_app.root_path
    end

    private

    # Check user's password against pwned password service and warn if necessary
    def check_for_pwnage( resource )
      return unless resource.try( :pwned? )

      # :nocov:
      set_flash_message! :alert, :warn_pwned
      # :nocov:
    end
  end
end
