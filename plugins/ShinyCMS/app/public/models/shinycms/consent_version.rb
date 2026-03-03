# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model to store the full text that users of the site may be asked to agree to, for GDPR compliance
  class ConsentVersion < ApplicationRecord
    # Custom error class
    class HasBeenAgreedTo < StandardError; end

    include ShinyCMS::HasSlug
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Validations

    validates :name,         presence: true
    validates :display_text, presence: true

    # Before actions

    before_update  :before_update
    before_destroy :before_destroy

    # Scopes

    scope :recent, -> { order( updated_at: :desc ) }

    scope :with_subscriptions, -> { includes( [ :subscriptions ] ) }

    # Instance methods

    alias_attribute :slug_base, :name

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
end
