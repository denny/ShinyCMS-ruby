# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper method for retrieving site settings
  module SettingsHelper
    def setting( name )
      ShinyCMS::Setting.readonly.get( name, current_user )
    end
  end
end
