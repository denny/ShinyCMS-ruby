# Base class for main site controllers
class ApplicationController < ActionController::Base
  theme_name = Rails.application.config.theme_name
  layout "themes/#{theme_name}/layouts/#{theme_name}"

  # Strong params config for various Devise features
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

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Override post-login redirect to take us to user's profile page
  # Check user's password against pwned password service and warn user if found
  def after_sign_in_path_for( resource )
    if resource.respond_to?( :pwned? ) && resource.pwned?
      # :nocov:
      set_flash_message! :alert, :warn_pwned
      # :nocov:
    end

    user_profile_path( resource )
  end

  protected

  # Strong params config for Devise
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
end
