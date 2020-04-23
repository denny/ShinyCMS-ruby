# frozen_string_literal: true

# Theme model, to group some repeated code
class Theme
  attr_accessor :name

  def initialize( theme_name )
    return unless Theme.files_exist?( theme_name )

    self.name = theme_name
  end

  delegate :present?, to: :name
  delegate :blank?,   to: :name

  def view_path
    "app/views/themes/#{name}"
  end

  def page_templates_path
    "#{view_path}/pages/templates"
  end

  # Check if the base directory matching a theme name exists on disk
  def self.files_exist?( theme_name )
    return false if theme_name.blank?

    FileTest.directory?( Rails.root.join( 'app/views/themes', theme_name ) )
  end

  # Find and return the current theme (if any)
  def self.current( user = nil )
    user_theme( user ) || site_theme || default_theme
  end

  def self.user_theme( user )
    return if user.blank?

    theme_name = Setting.get :theme_name, user
    Theme.new( theme_name ).presence
  end

  def self.site_theme
    theme_name = Setting.get :theme_name
    Theme.new( theme_name ).presence
  end

  def self.default_theme
    Theme.new( env_shinycms_theme ).presence
  end

  def self.env_shinycms_theme
    ENV['SHINYCMS_THEME']
  end
end
