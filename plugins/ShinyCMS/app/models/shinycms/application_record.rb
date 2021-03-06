# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Base model class
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # Don't ask me why Rails is failing to use its own methods consistently...
    def self.table_name
      name.tableize.sub( '/', '_' )
    end
  end
end
