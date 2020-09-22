# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Base controller for newsletter features on main site - part of ShinyNewsletters plugin for ShinyCMS
  # Inherits from ShinyCMS MainController
  class MainController < ::MainController
    helper Rails.application.routes.url_helpers
  end
end
