# Model class for comments
class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :comments, inverse_of: :parent,
                      foreign_key: :parent_id,
                      dependent: :destroy

  validates :discussion_id, presence: true
  validates :number, uniqueness: { scope: :discussion_id }

  validates :body,  presence: true, unless: -> { title.present? }
  validates :title, presence: true, unless: -> { body.present?  }

  # Instance methods

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
