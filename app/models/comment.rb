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
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :user,   inverse_of: :comments, optional: true

  has_many :comments, -> { where( spam: false ) },  inverse_of: :parent,
                                                    foreign_key: :parent_id,
                                                    dependent: :destroy

  # Validations

  validates :author_type,   presence: true
  validates :discussion_id, presence: true
  validates :body,          presence: true, unless: -> { title.present? }
  validates :title,         presence: true, unless: -> { body.present?  }
  validates :user_id,       presence: true, if:     -> { author_type == 'authenticated'}

  validates :number, uniqueness: { scope: :discussion_id }

  validates_with EmailAddress::ActiveRecordValidator,
                 field: :author_email, if: -> { author_email.present? }

  # Before/after actions

  before_create :set_number
  after_create  :send_notifications

  # Plugins

  acts_as_votable

  # Aliases

  alias_attribute :author, :user

  # Scopes

  scope :top_level, -> { where( parent: nil   ).order( :number ) }

  scope :since, ->( date ) { where( 'posted_at > ?', date ) }

  # Instance methods

  def set_number
    self.number = ( discussion.all_comments.maximum( :number ) || 0 ) + 1
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

  def author_name_any
    return author.name if author_type == 'authenticated'
    return author_name if author_type == 'pseudonymous' && author_name.present?

    'Anonymous'
  end

  def notifiable?
    author_email.present? || author.present?
  end

  def notification_email
    return unless notifiable?

    author_email.presence || author.email
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

  def self.all_spam
    where( spam: true ).order( :created_at )
  end
end
