# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for retrieving site settings
  module WithSettings
    extend ActiveSupport::Concern

    class_methods do
      def setting( name )
        current_user ||= nil
        ShinyCMS::Setting.readonly.get( name, current_user )
      end
    end
  end
end
