# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper method that returns your site's name
  module SiteNameHelper
    def site_name
      ShinyCMS::Setting.get( :site_name ) || I18n.t( 'site_name' )
    end
  end
end
