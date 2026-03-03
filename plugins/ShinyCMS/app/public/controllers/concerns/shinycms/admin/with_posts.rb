# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Common methods for admin controllers that handle ShinyCMS::Posts
    module WithPosts
      extend ActiveSupport::Concern

      include ShinyCMS::Admin::WithDateTimeInputs
      include ShinyCMS::Admin::WithDiscussions
      include ShinyCMS::Admin::WithTags

      included do
        helper_method :admin_tag_list
        helper_method :with_html_editor?

        def enforce_change_author_capability_for_create( category )
          params[ :post ][ :user_id ] = current_user.id unless current_user.can? :change_author, category
        end

        def enforce_change_author_capability_for_update( category )
          params[ :post ].delete( :user_id ) unless current_user.can? :change_author, category
        end

        # Return true if the page we're on might need a WYSIWYG HTML editor
        def with_html_editor?
          %w[ new edit ].include? action_name
        end
      end
    end
  end
end
