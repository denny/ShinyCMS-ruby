# Model class for comments
class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :author, class_name: 'User',    optional: true
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :comments, inverse_of: :parent,
                      foreign_key: :parent_id,
                      dependent: :destroy

  validates :discussion_id, presence: true
  validates :number, uniqueness: { scope: :discussion_id }

  validates :body,  presence: true, unless: -> { title.present? }
  validates :title, presence: true, unless: -> { body.present?  }

  after_create :send_notifications

  # Instance methods

  def send_notifications
    if parent.present? && parent.notification_email.present?
      to_parent_comment_author
      p = parent.notification_email
    end

    to_discussion_owner unless discussion.notification_email == p

    return if [ discussion.notification_email, p ]
              .include? Setting.get :all_comment_notifications_email

    to_all_comment_notifications_email
  end

  def to_parent_comment_author
    DiscussionMailer.parent_comment_notification( self )
  end

  def to_discussion_owner
    DiscussionMailer.discussion_notification( self )
  end

  def to_all_comment_notifications_email
    DiscussionMailer.overview_notification( self )
  end

  def author_name_any
    return author.display_name_or_username if author.present?

    author_name || 'Anonymous'
  end

  def notification_email
    return author.email if author.present?

    author_email
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
end
