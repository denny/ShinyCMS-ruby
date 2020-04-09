Rails.application.config.to_prepare do
  # Make Blazer appear inside our admin UI
  ::Blazer::BaseController.layout 'admin/layouts/admin_area'

  # Make the main_app url helpers available to Blazer's views
  ::Blazer::BaseController.helper MainAppRouteDelegator
end
