# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

Rails.application.config.to_prepare do
  # Make Blazer appear inside our admin UI
  ::Blazer::BaseController.layout 'admin/layouts/admin_area'

  # Make the main_app url helpers available to Blazer's views
  ::Blazer::BaseController.helper MainAppRouteDelegator
end
