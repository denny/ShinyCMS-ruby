# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base controller for 'main site'; end-user-facing ShinyCMS features
class MainController < ApplicationController
  include FeatureFlagsHelper

  Plugin.with_main_site_helpers.each do |plugin|
    helper plugin.main_site_helper
  end

  before_action :set_view_paths
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action  :track_ahoy_visit

  # Strong params config for Devise
  # rubocop:disable Layout/MultilineArrayLineBreaks
  SIGN_UP_PARAMS = %i[
    username email password password_confirmation
  ].freeze
  private_constant :SIGN_UP_PARAMS
  SIGN_IN_PARAMS = %i[
    username email password password_confirmation login remember_me
  ].freeze
  private_constant :SIGN_IN_PARAMS
  ACCOUNT_UPDATE_PARAMS = %i[
    username email password password_confirmation current_password
    display_name display_email profile_pic bio website location postcode
  ].freeze
  private_constant :ACCOUNT_UPDATE_PARAMS
  # rubocop:enable Layout/MultilineArrayLineBreaks

  layout 'layouts/main_site'

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

    return URI( request.referer ).path if can_redirect_to_referer_after_login?

    return admin_path if resource.can? :view_admin_area

    return shiny_profiles.profile_path( resource.username ) if feature_enabled?( :profile_pages )

    root_path
  end

  private

  def set_view_paths
    # Add the default templates directory to the top of view_paths
    prepend_view_path 'app/views/shinycms'

    # Add the default templates directory for any loaded plugins above that
    Plugin.with_views.each do |plugin|
      prepend_view_path plugin.view_path
    end

    # Apply the configured theme, if any, by adding it above the defaults
    prepend_view_path Theme.current( current_user ).view_path if Theme.current( current_user )
  end

  # Check user's password against pwned password service and warn if necessary
  def check_for_pwnage( resource )
    return unless resource.try( :pwned? )

    # :nocov:
    set_flash_message! :alert, :warn_pwned
    # :nocov:
  end

  def can_redirect_to_referer_after_login?
    request.referer.present? && request.referer != new_user_session_url
  end

  # Track all actions with Ahoy
  def track_ahoy_visit
    ahoy.track 'Ran action', request.path_parameters
  end
end
