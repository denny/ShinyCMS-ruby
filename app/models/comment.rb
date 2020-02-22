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

  # Instance methods

  def send_notifications
    parent = parent.notification_email
    owner  = discussion.notification_email
    all    = SiteSetting.get :all_comment_notifications_email

    to_parent_comment_author( parent )
    to_discussion_owner( owner ) unless owner == parent
    to_overview_address( all   ) unless all   == parent || all == owner
  end

  def to_parent_comment_author( email )
    return if email.blank?

    DiscussionMailer.parent_comment_notification( self )
  end

  def to_discussion_owner( email )
    return if email.blank?

    DiscussionMailer.discussion_notification( self )
  end

  def to_overview_address( email )
    return if email.blank?

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
