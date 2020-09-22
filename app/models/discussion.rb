# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model class for discussions (used to group comments)
class Discussion < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyShowHide

  # Assocations

  belongs_to :resource, inverse_of: :discussion, polymorphic: true

  has_many :comments, -> { where( spam: false ) }, inverse_of: :discussion, dependent: :destroy
  has_many :all_comments, inverse_of: :discussion, dependent: :destroy, class_name: 'Comment'
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
