# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Make the root URL for the main app available outside of controllers
  module MainAppRootURL
    def main_app_root_url
      options = Rails.application.config.action_mailer.default_url_options

      Rails.application.routes.url_helpers.root_url( **options )
    end

    # Remove the trailing /
    def main_app_base_url
      main_app_root_url.chop
    end
  end
end
