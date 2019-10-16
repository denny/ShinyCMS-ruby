# Base class for main site controllers
class ApplicationController < ActionController::Base
  layout 'main_site'

  include MainSiteMenu
  before_action :build_menu_data
end
