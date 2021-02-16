# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Helper methods for user profiles
  module MainSiteHelper
    def plugins_with_profile_content_templates
      ShinyCMS::Plugin.with_template( 'profile/_content.html.erb' ).collect( &:name ).collect( &:underscore )
    end
  end
end
