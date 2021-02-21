# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Main site base controller for the ShinyBlogs plugin for ShinyCMS
  # Inherits from ShinyCMS core plugin MainController
  class MainController < ShinyCMS::MainController
    helper Rails.application.routes.url_helpers
  end
end
