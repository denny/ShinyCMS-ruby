# Base class for admin controllers
class AdminController < ApplicationController
  layout 'admin/layouts/admin_area'

  def index
    # Redirect somewhere useful if logged in, or to admin login page if not
    redirect_to admin_pages_path
  end
end
