# Make Blazer appear inside our admin UI
Rails.application.config.to_prepare do
  Blazer::BaseController.layout 'admin/layouts/admin_area'
end
