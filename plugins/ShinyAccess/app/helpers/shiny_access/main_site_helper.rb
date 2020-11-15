# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Helper for checking access group membership status - part of the ShinyAccess plugin for ShinyCMS
  module MainSiteHelper
    def current_user_can_access?( access_group_slug )
      return false unless user_signed_in?

      current_user.access_groups.exists? slug: access_group_slug.to_s
    end
  end
end
