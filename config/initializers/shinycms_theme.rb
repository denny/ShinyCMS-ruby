# Set the main site theme, after sanity checks
class ShinyCMSError < StandardError
end

def use_theme( theme_name )
  path_parts = %W[ app views themes #{theme_name} ]
  theme_dir = Rails.root.join( *path_parts )
  return unless File.directory? theme_dir

  layout_file = "#{theme_dir}/layouts/#{theme_name}.html.erb"
  Rails.application.config.theme_name = theme_name if File.file? layout_file
end

Rails.application.config.theme_name = nil

if ENV['SHINYCMS_THEME'].present?
  use_theme ENV['SHINYCMS_THEME']
  if Rails.application.config.theme_name.nil?
    Rails.logger.warn "Templates missing for '#{ENV['SHINYCMS_THEME']}'"
  end
end

use_theme 'shinycms' if Rails.application.config.theme_name.nil?

if Rails.application.config.theme_name.nil?
  raise ShinyCMSError, 'Default templates missing'
end
