# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Allow other plugins to find users
  module WithUsers
    extend ActiveSupport::Concern

    included do
      def user_with_id( id )
        ShinyCMS::User.find( id )
      end

      def user_with_email( address )
        ShinyCMS::User.find_by( email: address )
      end

      def user_with_username( username )
        ShinyCMS::User.find_by( username: username )
      end
    end

    class_methods do
      def user_with_username( username )
        ShinyCMS::User.find_by( username: username )
      end
    end
  end
end
