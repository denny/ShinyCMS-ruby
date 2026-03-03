# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render the contents of the <head> section in the admin area
    class UserMenuComponent < ApplicationComponent
      def initialize( user:, hide_pic: )
        @admin_name        = user.name
        @admin_username    = user.username
        @admin_profile_id  = user.profile.id if profile?( user )
        @admin_profile_pic = profile_pic( user ) unless hide_pic
      end

      def profile?( user )
        ShinyCMS.plugins.loaded?( :ShinyProfiles ) && user.profile.present?
      end

      def profile_pic?( user )
        profile?( user ) && user.profile_with_pic.profile_pic.attached?
      end

      def profile_pic( user )
        return user.profile_with_pic.profile_pic if profile_pic?( user )
      end
    end
  end
end
