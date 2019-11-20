# Helpers for code dealing with Page/Template/etc elements
module ElementsHelper
  # Provide list of known element types (short text, long text, etc)
  def content_types
    I18n.t( 'admin.elements' ).values
  end

  # Provide filenames for use in select inputs for filename elements
  def select_filenames( path = nil )
    path ||= Rails.root.join(
      'public', 'images', Rails.application.config.theme_name
    )
    filenames = Dir.glob '*?.?*', base: path
    filenames.sort
  end
end
