# Theme model, to group some repeated code
class Theme
  attr_accessor :name

  def initialize( name )
    self.name = name
  end

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

  # Find the current theme, if any
  def self.current
    name = Setting.get( 'theme_name' )
    return Theme.new( name ) if files_exist?( name )

    name = ENV['SHINYCMS_THEME']
    return Theme.new( name ) if files_exist?( name )
  end
end
