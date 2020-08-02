# frozen_string_literal: true

# Model class for discussions (used to group comments)
class Discussion < ApplicationRecord
  include ShinyShowHide

  # Assocations

  belongs_to :resource, inverse_of: :discussion, polymorphic: true

  has_many :comments, -> { where( spam: false ) }, inverse_of: :discussion, dependent: :destroy
  has_many :all_comments, class_name: 'Comment',   inverse_of: :discussion, dependent: :destroy
  # TODO: Get rid of .all_comments; only used to find the next .number when creating a new comment

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

  # Class methods

  def self.recently_active( days: 7, count: 10 )
    counts = Comment.visible.since( days.days.ago ).group( :discussion_id )
                    .order( 'count(id) desc' ).limit( count ).count

    discussions = where( id: counts.keys )

    [ discussions, counts ]
  end
end
