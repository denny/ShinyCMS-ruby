# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for an edition of a newsletter
  class Edition < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinyShowHide
    include ShinySlugInMonth
    include ShinySoftDelete
    include ShinyWithTemplate

    # Associations

    belongs_to :template, inverse_of: :editions

    has_many :sends,    inverse_of: :edition, dependent: :restrict_with_error
    has_many :elements, -> { order( :position ) }, inverse_of: :edition, dependent: :destroy,
                                                   class_name: 'EditionElement'

    accepts_nested_attributes_for :elements

    # Scopes

    scope :recently_updated, -> { order( updated_at: :desc ) }

    # Instance methods

    def sent?
      sends&.sent&.present?
    end

    def scheduled?
      sends&.scheduled&.present?
    end

    def send_sample( recipient )
      NewsletterMailer.send_email( self, recipient ).deliver_later
    end

    # Used by SlugInMonth validator
    def items_in_same_month
      self.class.readonly.where( updated_at: Time.zone.now.all_month )
    end
  end
end
