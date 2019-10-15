# Base class for main site controllers
class ApplicationController < ActionController::Base
  layout 'main_site'

  def after_sign_in_path_for(resource)
    set_flash_message! :alert, :warn_pwned if resource.respond_to?( :pwned? ) &&
                                              resource.pwned?
    super
  end
end
