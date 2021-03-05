# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Rails Email Preview controller for previewing Discussion-related emails
class DiscussionMailerPreview
  def parent_comment_notification
    ShinyCMS::DiscussionMailer.parent_comment_notification fetch_comment
  end

  def discussion_notification
    ShinyCMS::DiscussionMailer.discussion_notification fetch_comment
  end

  def overview_notification
    ShinyCMS::DiscussionMailer.overview_notification fetch_comment
  end

  private

  def fetch_comment
    @comment_id ? ShinyCMS::Comment.find( @comment_id ) : mock_comment
  end

  def mock_comment
    comments = ShinyCMS::Comment.where( show_on_site: true, spam: false )
    comments.where.not( parent: nil ).last || comments.last
  end
end
