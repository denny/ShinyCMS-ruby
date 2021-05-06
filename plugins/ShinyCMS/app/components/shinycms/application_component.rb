# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Base view component - part of the ShinyCMS core plugin
  class ApplicationComponent < ViewComponent::Base
    include ShinyCMS::ViewComponentHelper

    def shinycms
      ShinyCMS::Engine.routes.url_helpers
    end

    def rails_email_preview
      RailsEmailPreview::Engine.routes.url_helpers
    end

    def main_app
      Rails.application.routes.url_helpers
    end
  end
end
