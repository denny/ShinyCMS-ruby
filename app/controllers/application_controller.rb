# Base class for main site controllers
class ApplicationController < ActionController::Base
  include FeatureFlagsHelper

  before_action :set_default_view_path
  before_action :apply_theme
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout 'layouts/main_site.html.erb'

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

    # Override post-login redirect to take us to user's profile page
    user_profile_path( resource.username )
  end

  def set_default_view_path
    # Set the default view path for the main site to the base ShinyCMS
    # templates, which themes can then override, wrap, or fall back to
    # TODO: this should probably be done in config rather than here?
    # TODO: FIXME: this should remove default path (app/views)

    # FIXME: this is horrible, and doesn't work anyway!
    # paths_to_keep = view_paths.to_ary
    # paths_to_keep.shift
    # tmp_paths = prepend_view_path 'app/views/shinycms'
    # new_path = tmp_paths.shift
    # new_paths = [ new_path, *paths_to_keep ]
    # view_paths = new_paths
    # view_paths

    # FIXME: this adds the new path but doesn't remove the default one
    prepend_view_path 'app/views/shinycms'
  end

  # Check if the base directory matching a theme name exists on disk
  def theme_exists?( theme_name )
    return false if theme_name.blank?

    FileTest.directory?( Rails.root.join( 'app/views/themes', theme_name ) )
  end

  # Apply the configured theme, if any, by adding it to front of view paths
  def apply_theme
    theme_name = Setting.get( 'theme_name' )
    if theme_exists?( theme_name )
      prepend_view_path "app/views/themes/#{theme_name}"
      return
    end

    theme_name = ENV['SHINYCMS_THEME']
    return unless theme_exists?( theme_name )

    prepend_view_path "app/views/themes/#{theme_name}"
  end
end
