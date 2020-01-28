# Base class for main site controllers
class ApplicationController < ActionController::Base
  include FeatureFlagsHelper

  before_action :store_return_to
  before_action :set_view_paths
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout 'layouts/main_site'

  protected

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
    # Check user's password against pwned password service and warn if necessary
    if resource.respond_to?( :pwned? ) && resource.pwned?
      # :nocov:
      set_flash_message! :alert, :warn_pwned
      # :nocov:
    end

    # Override post-login redirect
    return request.referer if request.referer && request.referer != new_user_session_url
    return admin_path      if resource.can? :view_admin_area
    user_profile_path( resource.username )
  end

  def store_return_to
    session[ :return_to ] = request.url
  end

  def set_view_paths
    # Add the default templates directory to the top of view_paths
    prepend_view_path 'app/views/shinycms'
    # Apply the configured theme, if any, by adding it above the defaults
    prepend_view_path Theme.current.view_path if Theme.current
  end
end
