# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model to store the full text that users of the site may be asked to agree to, for GDPR compliance
class ConsentVersion < ApplicationRecord
  # Custom error class
  class HasBeenAgreedTo < StandardError; end

  include ShinyDemoDataProvider
  include ShinySlug
  include ShinySoftDelete

  # Validations

  validates :name,         presence: true
  validates :display_text, presence: true

  # Before actions

  before_update  :before_update
  before_destroy :before_destroy

  # Instance methods

  def before_update
    return if subscriptions.blank?

    raise HasBeenAgreedTo, 'You cannot change the details of a consent version that people have already agreed to'
  end

  def before_destroy
    return if subscriptions.blank?

    raise HasBeenAgreedTo, 'You cannot delete a consent version that people have already agreed to'
  end

  # Class methods

  def self.admin_search( search_term )
    where( 'name ilike ?', "%#{search_term}%" )
      .or( where( 'slug ilike ?', "%#{search_term}%" ) )
      .order( updated_at: :desc )
  end
end
