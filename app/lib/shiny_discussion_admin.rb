# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods that any admin controller handling content with a Discussions might want
module ShinyDiscussionAdmin
  def extract_discussion_flags_from_params( request_params )
    show = ( request_params.delete( :discussion_show_on_site ) || 0 ).to_i == 1
    lock = ( request_params.delete( :discussion_locked       ) || 0 ).to_i == 1

    [ show, lock ]
  end

  def create_discussion_or_update_flags( resource, show, lock )
    if resource.discussion.present?
      resource.discussion.update!( show_on_site: show, locked: lock )
    elsif show
      Discussion.create!( resource: @post, show_on_site: show, locked: lock )
    end
  end
end
