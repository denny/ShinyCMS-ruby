# Base class for main site controllers
class ApplicationController < ActionController::Base
  layout 'main_site'

  # Strong params config for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Check logins against pwned password service and warn user if necessary
  def after_sign_in_path_for( resource )
    if resource.respond_to?( :pwned? ) && resource.pwned?
      # :nocov:
      set_flash_message! :alert, :warn_pwned
      # :nocov:
    end

    super
  end

  protected

  # Strong params config for Devise
  def configure_permitted_parameters
    basic_params = %i[ username email password password_confirmation ]

    devise_parameter_sanitizer.permit( :sign_up ) do |user_params|
      user_params.permit( basic_params )
    end

    devise_parameter_sanitizer.permit( :sign_in ) do |user_params|
      user_params.permit( basic_params | %i[ login remember_me ] )
    end

    devise_parameter_sanitizer.permit( :account_update ) do |user_params|
      user_params.permit( basic_params | %i[ current_password display_name ] )
    end
  end
end
