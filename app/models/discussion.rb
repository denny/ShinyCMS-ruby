# frozen_string_literal: true

# Model class for discussions (used to group comments)
class Discussion < ApplicationRecord
  belongs_to :resource, inverse_of: :discussion, polymorphic: true

  has_many :all_comments, class_name: 'Comment',
                          foreign_key: :discussion_id,
                          inverse_of: :discussion,
                          dependent: :destroy

  # Instance methods

  def comments
    all_comments.where( spam: false ).order( :number )
  end

  def top_level_comments
    comments.where( parent: nil )
  end

  def visible_comments
    comments.where( hidden: false )
  end

  def visible_comment_count
    visible_comments.count
  end

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

  def hide
    update( hidden: true )
  end

  def unhide
    update( hidden: false )
  end

  # Class methods

  def self.recently_active( days: 7, count: 10 )
    counts = Comment.visible.since( days.days.ago ).group( :discussion_id )
                    .order( 'count(id) desc' ).limit( count ).count

    discussions = where( id: counts.keys )

    [ discussions, counts ]
  end
end
