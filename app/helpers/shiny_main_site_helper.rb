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

  include ActsAsTaggableOn::TagsHelper

  def current_user_can?( capability, category = :general )
    current_user&.can? capability, category
  end

  def current_user_is_admin?
    current_user&.admin?
  end

  def current_user_is_not_admin?
    !current_user_is_admin?
  end

  def consent_version( slug )
    ConsentVersion.find_by( slug: slug )
  end

  def setting( name )
    Setting.get( name, current_user )
  end

  def user_profile_link( user = current_user )
    link_to user.name, shiny_profiles.profile_path( user.username )
  end
end
