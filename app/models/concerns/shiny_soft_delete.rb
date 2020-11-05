# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Add soft delete to a model (mark data as deleted and hide it, but don't actually delete from database)
module ShinySoftDelete
  extend ActiveSupport::Concern

  included do
    acts_as_paranoid
    validates_as_paranoid
  end
end
