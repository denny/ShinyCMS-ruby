# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Default config and common behaviours for models with pagination
module ShinyPaging
  extend ActiveSupport::Concern

  included do
    paginates_per 10
  end
end
