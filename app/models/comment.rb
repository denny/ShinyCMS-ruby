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
    send_notification_to_parent_author if parent.notification_email.present?
    if discussion.resource.notification_email.present?
      send_reply_to_content_author
    end
    send_site_admin if SiteSetting.get( :all_notifications_email ).present?
  end

  def send_notification_to_parent_author
    DiscussionMailer.reply_to_comment( self )
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
