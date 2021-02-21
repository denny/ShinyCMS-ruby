# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Part of the Pundit-powered ACL - group capabilities by site area, e.g. :pages
  class CapabilityCategory < ApplicationRecord
    include ShinySoftDelete

    # Associations

    has_many :capabilities, inverse_of: :category, foreign_key: :category_id, dependent: :restrict_with_error
  end
end
