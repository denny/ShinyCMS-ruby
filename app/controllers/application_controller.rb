# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# :nocov:
class ApplicationController < ActionController::Base
  def index
    render inline: 'Hello world.'
  end
end
# :nocov:
