# Base class for admin controllers
class AdminController < ApplicationController
  before_action :check_admin_ip_list
  # before_action :authenticate_user!

  include Pundit

  layout 'admin/layouts/admin_area'

  # TODO: Redirect admins based on their ACL; 'Can edit news posts' to News, etc
  def index
    redirect_to admin_pages_path
  end

  private

  # Check whether a list of permitted admin IP addresses has been defined,
  # and if one has, then redirect anybody not coming from one of those IPs.
  def check_admin_ip_list
    allowed = Setting.get I18n.t( 'settings.admin_ip_list' )
    return if allowed.blank?

    return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

    redirect_to root_path
  end
end
