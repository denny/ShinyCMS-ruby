# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Rails Email Preview controller for previewing Discussion-related emails
  class DiscussionMailerPreview
    def parent_comment_author_notification
      ShinyCMS::DiscussionMailer.with( comment: preview_comment ).parent_comment_author_notification
    end

    def content_author_notification
      ShinyCMS::DiscussionMailer.with( comment: preview_comment ).content_author_notification
    end

    def comment_admin_notification
      ShinyCMS::DiscussionMailer.with( comment: preview_comment ).comment_admin_notification
    end

    private

    def preview_comment
      comments = ShinyCMS::Comment.where( show_on_site: true, spam: false )
      comments.where.not( parent: nil ).last || comments.last
    end
  end
end
