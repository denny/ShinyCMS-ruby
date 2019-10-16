# Base class for main site controllers
class ApplicationController < ActionController::Base
  layout 'main_site'

  include Menu
  before_action :build_menu_data
end
