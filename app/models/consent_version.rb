# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model to store the full text that users of the site may be asked to agree to, for GDPR compliance
class ConsentVersion < ApplicationRecord
  # Custom error class
  class HasBeenAgreedTo < StandardError; end

  include ShinyDemoDataProvider
  include ShinySlug

  # Validations

  validates :name,         presence: true
  validates :display_text, presence: true

  # Plugin features

  acts_as_paranoid
  validates_as_paranoid

  # Before actions

  before_update  :before_update
  before_destroy :before_destroy

  def before_update
    return if subscriptions.blank?

    raise HasBeenAgreedTo, 'You cannot change the details of a consent version that people have already agreed to'
  end

  def before_destroy
    return if subscriptions.blank?

    raise HasBeenAgreedTo, 'You cannot delete a consent version that people have already agreed to'
  end
end
