# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods that might be useful in templates and/or controllers on the main site
module ShinyMainSiteHelper
  include ShinyDiscussionHelper
  include ShinyPluginHelper
  include ShinySiteNameHelper
  include ShinyUserHelper

  include ActsAsTaggableOn::TagsHelper

  def consent_version( slug )
    ConsentVersion.find_by( slug: slug )
  end

  def setting( name )
    Setting.get( name, current_user )
  end
end
