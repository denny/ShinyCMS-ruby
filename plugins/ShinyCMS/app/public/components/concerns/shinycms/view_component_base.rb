# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for view components - part of the ShinyCMS core plugin
  module ViewComponentBase
    extend ActiveSupport::Concern

    included do
      include ShinyCMS::ViewComponentHelper

      # Make url_helpers available to plugin components even when rendered by other engines
      url_helpers = ShinyCMS.plugins.names.collect { |name| name.to_s.underscore.to_sym }
      delegate :shinycms, *url_helpers, :main_app, :rails_email_preview, :blazer, to: :helpers
    end
  end
end
