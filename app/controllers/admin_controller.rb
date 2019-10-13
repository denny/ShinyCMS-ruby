# Base class for admin controllers
class AdminController < ApplicationController
  layout 'admin/layouts/admin_area'

  before_action :check_admin_ip_list

  # Check whether a list of permitted admin IP addresses has been defined,
  # and if one has, then redirect anybody not coming from one of those IPs.
  def check_admin_ip_list
    allowed = Setting.get I18n.t( 'admin_ip_list' )
    return if allowed.blank?

    return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

    redirect_to url_for '/'
  end

  def index
    # Redirect somewhere useful if logged in, or to admin login page if not
    redirect_to admin_pages_path
  end
end
