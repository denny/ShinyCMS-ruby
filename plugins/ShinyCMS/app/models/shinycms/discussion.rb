# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model class for discussions (used to group comments)
  class Discussion < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Assocations

    belongs_to :resource, inverse_of: :discussion, polymorphic: true

    has_many :comments, -> { not_spam.includes( [ :author ] ) }, inverse_of: :discussion, dependent: :destroy
    has_many :all_comments, inverse_of: :discussion, dependent: :destroy, class_name: 'Comment'
    # TODO: Get rid of .all_comments; only used to find the next .number when creating a new comment

    # Scopes

    scope :with_authors,  -> { includes( [ :author   ] ) }
    scope :with_comments, -> { includes( [ :comments ] ) }

    # Instance methods

    def notifiable?
      resource&.user&.email.present?
    end

    def notification_email
      return unless notifiable?

      resource.user.email
    end

    def lock
      update( locked: true )
    end

    def unlock
      update( locked: false )
    end

    def find_comment( number: )
      comment = comments.find_by( number: number )
      return comment if comment.present?

      raise ActiveRecord::RecordNotFound
    end

    def next_comment_number
      ( all_comments.maximum( :number ) || 0 ) + 1
    end

    def most_recent_comment
      comments.order( posted_at: :desc ).first
    end

    # Class methods

    # Trigger whichever notification emails are appropriate for a given comment
    def self.send_notifications( comment )
      parent_author, content_author, admin = email_addresses_to_notify( comment )

      mailer = DiscussionMailer.with( comment: comment )

      mailer.parent_comment_author_notification if parent_author.present?

      mailer.content_author_notification unless blank_or_already_emailed? content_author, [ parent_author ]

      mailer.comment_admin_notification unless blank_or_already_emailed? admin, [ parent_author, content_author ]
    end

    def self.email_addresses_to_notify( comment )
      [
        comment.parent&.notification_email,
        comment.discussion.notification_email,
        ShinyCMS::Setting.get( :all_comment_notifications_email )
      ]
    end

    def self.blank_or_already_emailed?( email, previous_emails )
      ( [ nil, '' ] + previous_emails ).include? email
    end

    def self.recently_active( days: 7, count: 10 )
      counts = Comment.visible.since( days.days.ago ).group( :discussion_id )
                      .order( 'count(id) desc' ).limit( count ).count

      discussions = where( id: counts.keys )

      [ discussions, counts ]
    end

    def self.my_demo_data_position
      10  # hopefully higher than any content types that might have discussions attached
    end
  end
end
