# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# ShinyHostApp base controller

# MainController instead of ApplicationController because Blazer inherits from
# the latter, which means ApplicationController has a lot of admin stuff in it.

# rubocop:disable Rails/ApplicationController
class MainController < ActionController::Base
  def index
    # rubocop:disable Rails/RenderInline
    render inline: 'Hello world.'
    # rubocop:enable Rails/RenderInline
  end
end
# rubocop:enable Rails/ApplicationController
