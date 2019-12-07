# Base class for main site controllers
class ApplicationController < ActionController::Base
  include FeaturesHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Use the layout from the theme that was set in the shinycms_theme initializer
  theme_name = Rails.application.config.theme_name
  layout "themes/#{theme_name}/layouts/#{theme_name}"

  protected

  # Strong params config for Devise
  SIGN_UP_PARAMS = %i[
    username email password password_confirmation
  ].freeze
  private_constant :SIGN_UP_PARAMS
  SIGN_IN_PARAMS = %i[
    username email password password_confirmation login remember_me
  ].freeze
  private_constant :SIGN_IN_PARAMS
  ACCOUNT_UPDATE_PARAMS = %i[
    username email password password_confirmation current_password display_name
  ].freeze
  private_constant :ACCOUNT_UPDATE_PARAMS

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

    # Override post-login redirect to take us to user's profile page
    user_profile_path( resource.username )
  end
end
