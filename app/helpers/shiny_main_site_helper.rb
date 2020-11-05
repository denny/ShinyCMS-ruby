# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Includes all of the helpers that might be useful in templates and/or controllers on the main site
module ShinyMainSiteHelper
  include ShinyConsentHelper
  include ShinyDiscussionHelper
  include ShinyFeatureFlagHelper
  include ShinyPluginHelper
  include ShinySettingsHelper
  include ShinySiteNameHelper
  include ShinyUserHelper

  include ActsAsTaggableOn::TagsHelper
end
