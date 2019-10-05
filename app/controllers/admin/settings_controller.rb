# Admin controller for CMS settings
class Admin::SettingsController < ApplicationController
  # Giant settings form
  def index
    @settings = SiteSettings.all.sort_by( :name )
  end

  # Form submitted; update any changed settings
  def update
    flash[ :status ] = 'Settings updated'
    render :index
  end
end
