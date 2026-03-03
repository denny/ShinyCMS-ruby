# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model class for comments
  class Comment < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::HasVotes
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Associations

    belongs_to :discussion
    belongs_to :parent, optional: true, class_name: 'Comment'
    belongs_to :author, optional: true, polymorphic: true, inverse_of: :comments

    has_many :comments, -> { not_spam }, inverse_of: :parent, foreign_key: :parent_id, dependent: :destroy

    # Validations

    validates :discussion_id, presence: true
    validates :body,          presence: true, unless: -> { title.present? }
    validates :title,         presence: true, unless: -> { body.present?  }

    validates :number, uniqueness: { scope: :discussion_id }

    # Before/after actions

    before_create :set_number
    after_create  :send_notifications

    # Scopes

    scope :recent,    -> { visible.merge( order( posted_at: :desc  ) ) }
    scope :top_level, -> { where( parent: nil ).order( :number     ) }
    scope :spam,      -> { where( spam: true  ).order( :created_at ) }
    scope :not_spam,  -> { where( spam: false ) }

    scope :with_authors,  -> { includes( [ :author   ] ) }
    scope :with_comments, -> { includes( [ :comments ] ) }

    scope :since, ->( date ) { where( 'posted_at > ?', date ) }

    # Instance methods

    def comments
      Comment.with_comments.with_authors.where( parent: id ).order( :number )
    end

    def set_number
      self.number = discussion.next_comment_number
    end

    # Returns the path to a comment's parent resource, anchored to this specific comment
    # (or to the top of the comment section, if this comment was just deleted or marked as spam)
    def anchored_path
      anchor = number
      anchor = 'comments' if destroyed? || spam?

      discussion.resource.path( anchor: anchor )
    end

    alias path anchored_path

    def send_notifications
      Discussion.send_notifications( self ) if FeatureFlag.enabled? :comment_notifications
    end

    def authenticated_author?
      author.is_a? ShinyCMS::User
    end

    def pseudonymous_author?
      author.is_a? ShinyCMS::PseudonymousAuthor
    end

    def anonymous_author?
      author.is_a? ShinyCMS::AnonymousAuthor
    end

    def notification_email
      author.email
    end

    def lock
      update( locked: true )
    end

    def unlock
      update( locked: false )
    end

    def mark_as_spam
      update( spam: true )
    end

    # Class methods

    def self.mark_all_as_ham( comment_ids )
      _shut_up_rubocop = where( id: comment_ids ).update( spam: false )
    end

    def self.admin_search( search_term )
      spam.where( 'title ilike ?', "%#{search_term}%" )
          .or( spam.where( 'body ilike ?', "%#{search_term}%" ) )
          .order( posted_at: :desc )
    end

    def self.my_demo_data_position
      11  # after discussions
    end
  end
end
