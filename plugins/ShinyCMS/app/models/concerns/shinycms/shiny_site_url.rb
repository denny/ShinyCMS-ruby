# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# For models that need to get the base URL for the content site
module ShinySiteURL
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers

    def site_base_url
      root_url.to_s.chop
    end

    private

    def default_url_options
      Rails.application.config.action_mailer.default_url_options
    end
  end
end
