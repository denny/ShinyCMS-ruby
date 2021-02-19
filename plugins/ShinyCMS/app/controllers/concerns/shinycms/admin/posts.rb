# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Common methods for admin controllers that handle Posts
    module Posts
      def enforce_change_author_capability_for_create( category )
        params[ :post ][ :user_id ] = current_user.id unless current_user.can? :change_author, category
      end

      def enforce_change_author_capability_for_update( category )
        params[ :post ].delete( :user_id ) unless current_user.can? :change_author, category
      end
    end
  end
end
