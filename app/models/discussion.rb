# Model class for discussions (used to group comments)
class Discussion < ApplicationRecord
  belongs_to :resource, inverse_of: :discussion, polymorphic: true

  has_many :comments, class_name: 'Comment',
                      foreign_key: :discussion_id,
                      inverse_of: :discussion,
                      dependent: :destroy

  # Instance methods

  def discussion_hidden
    hidden
  end

  def discussion_locked
    locked
  end

  def notification_email
    return if resource.blank?

    resource.author.email || resource.owner.email || resource.user.email || nil
  end

  def top_level_comments
    comments.where( parent: nil )
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
