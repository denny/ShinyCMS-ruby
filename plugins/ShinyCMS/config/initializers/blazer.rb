# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Persuade Blazer to sit inside the ShinyCMS admin UI.

# This config is pulled into main_app by /config/initializers/blazer.rb

Rails.application.config.to_prepare do
  # Wrap the ShinyCMS admin UI around Blazer's views
  Blazer::BaseController.prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'
  Blazer::BaseController.layout 'admin/layouts/admin_area'

  # Inject our standard IP allow-list check (if configured)
  Blazer::BaseController.before_action :enforce_allowed_ips
end
