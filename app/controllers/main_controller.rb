# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# ShinyHostApp base controller

# MainController instead of ApplicationController because Blazer inherits from
# ApplicationController. And to get Blazer to render inside the ShinyCMS admin
# UI, the ApplicationController includes a lot of admin-area capabilities and
# behaviour. Inherit from MainController instead. :)

# :nocov:
class MainController < ActionController::Base
  def index
    render inline: 'Hello world.'
  end
end
# :nocov:
