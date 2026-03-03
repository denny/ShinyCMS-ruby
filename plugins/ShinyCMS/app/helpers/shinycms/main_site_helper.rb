# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Includes all of the helpers that might be useful in templates and/or controllers on the main site
  module MainSiteHelper
    include ConsentHelper
    include DatesHelper
    include DiscussionsHelper
    include FeatureFlagsHelper
    include PluginsHelper
    include SettingsHelper
    include SiteNameHelper
    include TagsHelper
    include UsersHelper
    include ViewComponentHelper
  end
end
