# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for dealing with users
  module UsersHelper
    def current_user_can?( capability, category = :general )
      current_user&.can? capability, category
    end

    def current_user_is_admin?
      current_user&.admin?
    end

    def current_user_is_not_admin?
      !current_user_is_admin?
    end

    def user_profile_link( user = current_user )
      return user.name unless ShinyCMS.plugins.loaded? :ShinyProfiles

      link_to user.name, shiny_profiles.profile_path( user.username )
    end

    def users_that_can_for_menu( capability, category = nil )
      ShinyCMS::User.that_can( capability, category ).pluck( :username, :id ).sort_by( &:first )
    end
  end
end
