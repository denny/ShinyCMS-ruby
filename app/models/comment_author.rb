# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Details of unauthenticated comment authors
class CommentAuthor < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinySoftDelete
  include ShinyToken

  # Associations

  has_many :comments, as: :author, dependent: :nullify

  belongs_to :email_recipient, optional: true

  # Instance methods

  def email
    return if email_recipient.blank?

    email_recipient.email
  end
end
