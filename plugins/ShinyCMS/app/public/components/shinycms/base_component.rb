# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Base view component - part of the ShinyCMS core plugin
  class BaseComponent < ViewComponent::Base
    include ShinyCMS::ViewComponentHelper

    # Make url_helpers available to plugin components even when rendered by other engines
    url_helpers = ShinyCMS.plugins.with_view_components.collect( &:underscore ).collect( &:to_sym )
    delegate :shinycms, *url_helpers, :main_app, :rails_email_preview, :blazer, to: :helpers
  end
end
