# Base class for admin controllers
class AdminController < ApplicationController
  include Pundit
  include AdminAreaHelper

  before_action :check_admin_ip_list
  before_action :authenticate_user!

  skip_before_action :set_view_paths

  after_action :verify_authorized

  layout 'admin/layouts/admin_area'

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def index
    skip_authorization

    redirect_to root_path unless current_user.can? :view_admin_area

    # Redirect user based on which admin features they have access to (in order
    # of which one seems most likely to be useful if they have access to many)
    # TODO: Add a user-setting so admins can set their preferred landing page
    if current_user.can? :list, :pages
      redirect_to pages_path
    elsif current_user.can? :list, :blogs
      redirect_to blogs_path
    elsif current_user.can? :list, :users
      redirect_to users_path
    elsif current_user.can? :list, :settings
      redirect_to site_settings_path
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  private

  # Check whether a list of permitted admin IP addresses has been defined,
  # and if one has, then redirect anybody not coming from one of those IPs.
  def check_admin_ip_list
    allowed = Setting.get :admin_ip_list
    return if allowed.blank?

    return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

    redirect_to root_path
  end
end
