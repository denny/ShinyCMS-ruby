# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Interface
    # Make these two ActiveRecord methods available to other plugins
    class ConsentVersion
      def self.has_many( things, **args )
        ShinyCMS::ConsentVersion.has_many( things, **args )
      end

      def self.find_or_create_by!( **args )
        ShinyCMS::ConsentVersion.find_or_create_by!( **args )
      end
    end
  end
end
