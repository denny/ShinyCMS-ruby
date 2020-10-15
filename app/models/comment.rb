# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model class for comments
class Comment < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyShowHide

  # Associations

  belongs_to :discussion
  belongs_to :parent, optional: true, class_name: 'Comment'
  belongs_to :author, optional: true, polymorphic: true, inverse_of: :comments

  has_many :comments, -> { not_spam }, inverse_of: :parent, foreign_key: :parent_id, dependent: :destroy

  # Plugin features

  acts_as_votable
  acts_as_paranoid
  validates_as_paranoid

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

  scope :since, ->( date ) { where( 'posted_at > ?', date ) }

  # Instance methods

  def set_number
    self.number = discussion.next_comment_number
  end

  # Returns the path to a comment's parent resource, anchored to the comment
  # Tries to fall back gracefully if comment is deleted/marked as spam
  def anchored_path
    anchor = number
    anchor = 'comments' if destroyed? || spam?

    discussion.resource.path( anchor: anchor )
  end

  alias path anchored_path

  def send_notifications
    p = parent.notification_email if parent.present?
    notify_parent_comment_author if p.present?

    d = discussion.notification_email
    notify_discussion_owner unless d == p

    a = Setting.get :all_comment_notifications_email
    return if a.blank? || [ d, p ].include?( a )

    notify_all_comment_notifications_email
  end

  def notify_parent_comment_author
    DiscussionMailer.parent_comment_notification( self )
  end

  def notify_discussion_owner
    DiscussionMailer.discussion_notification( self )
  end

  def notify_all_comment_notifications_email
    DiscussionMailer.overview_notification( self )
  end

  def author_name_or_anon
    author&.name&.presence || I18n.t( 'discussions.anonymous' )
  end

  def authenticated_author?
    author_type == 'User'
  end

  def notification_email
    author&.email
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
end
