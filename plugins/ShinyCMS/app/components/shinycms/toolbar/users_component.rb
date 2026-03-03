# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Toolbar
    # Component to render Users section in admin toolbar on main site
    class UsersComponent < ApplicationComponent
      attr_reader :admin_user, :user_id

      def initialize( admin_user:, user_id: )
        @admin_user = admin_user
        @user_id    = user_id
      end
    end
  end
end
