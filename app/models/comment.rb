# frozen_string_literal: true

# Model class for comments
class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :user, inverse_of: :comments, optional: true
  alias_attribute :author, :user

  has_many :comments, -> { where( spam: false ) }, inverse_of: :parent,
                                                   foreign_key: :parent_id,
                                                   dependent: :destroy

  validates :discussion_id, presence: true
  validates :author_type, presence: true
  validates :user_id, presence: true, if: -> { author_type == 'authenticated'}

  validates :number, uniqueness: { scope: :discussion_id }

  validates :body,  presence: true, unless: -> { title.present? }
  validates :title, presence: true, unless: -> { body.present?  }

  validates_with EmailAddress::ActiveRecordValidator,
                 field: :author_email, if: -> { author_email.present? }

  before_create :set_number
  after_create  :send_notifications

  # Instance methods

  def set_number
    self.number = ( discussion.comments.maximum( :number ) || 0 ) + 1
  end

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
    return author.display_name_or_username if author_type == 'authenticated'
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

  def hide
    update( hidden: true )
  end

  def unhide
    update( hidden: false )
  end

  def mark_as_spam
    update( spam: true )
  end

  # Class methods

  def self.all_spam
    where( spam: true ).order( :created_at )
  end
end
