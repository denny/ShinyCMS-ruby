# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

Rails.application.config.to_prepare do
  # Embed Blazer in the ShinyCMS admin UI
  ::Blazer::BaseController.prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'
  ::Blazer::BaseController.layout 'admin/layouts/admin_area.html.erb'

  # Make ShinyCMS url_helpers available to Blazer's views
  ::Blazer::BaseController.helper ShinyCMS::RouteDelegator
end
