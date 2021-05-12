# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# NOTE: THIS CONTROLLER INHERITS FROM ONE IN THE SHINYCMS ADMIN AREA
#
# Inheriting from or otherwise using this controller for any additional purpose
# is probably a bad idea, for security reasons and for separation of concerns.

module Blazer
  # Used to embed Blazer into the ShinyCMS admin UI
  class ApplicationController < ShinyCMS::Admin::Tools::BlazerBaseController; end
end
