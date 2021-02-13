# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Provides .name method for anything with public_name and internal_name attributes
module ShinyName
  extend ActiveSupport::Concern

  included do
    validates :internal_name, presence: true

    def name
      public_name.presence || internal_name
    end
  end
end
