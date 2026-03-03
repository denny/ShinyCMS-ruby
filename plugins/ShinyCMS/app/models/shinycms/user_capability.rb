# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Links users and capabilities
  class UserCapability < ApplicationRecord
    include ShinyCMS::SoftDelete

    belongs_to :user
    belongs_to :capability
  end
end
