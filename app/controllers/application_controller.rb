# Base class for main site controllers
class ApplicationController < ActionController::Base
  layout 'main_site'

  # Strong params config for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Check logins against pwned password service and warn user if necessary
  def after_sign_in_path_for( resource )
    set_flash_message! :alert, :warn_pwned if resource.respond_to?( :pwned? ) &&
                                              resource.pwned?
    super
  end

  protected

  # Strong params config for Devise
  def configure_permitted_parameters
    keys1 = %i[ username email password password_confirmation ]
    devise_parameter_sanitizer.permit :sign_up, keys: keys1

    keys2 = %i[ username email password password_confirmation remember_me ]
    devise_parameter_sanitizer.permit :sign_in, keys: keys2

    keys3 = %i[ username email password password_confirmation current_password ]
    devise_parameter_sanitizer.permit :account_update, keys: keys3
  end
end
