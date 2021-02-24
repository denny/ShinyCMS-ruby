# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for element models (ShinyPages::PageElement, ShinyInserts::Element, etc)
  module ShinyElement
    extend ActiveSupport::Concern

    include ShinyCMS::SoftDelete

    # Allowed characters for element names: a-z A-Z 0-9 _
    ELEMENT_NAME_REGEX = %r{[_a-zA-Z0-9]+}
    private_constant :ELEMENT_NAME_REGEX
    ANCHORED_ELEMENT_NAME_REGEX = %r{\A#{ELEMENT_NAME_REGEX}\z}
    private_constant :ANCHORED_ELEMENT_NAME_REGEX

    included do
      # Associations

      has_one_attached :image

      # Validations

      validates :name, presence: true, format: ANCHORED_ELEMENT_NAME_REGEX

      before_validation :format_name, if: -> { name.present? }

      # Instance methods

      def format_name
        self.name = name.parameterize.underscore
      end
    end
  end
end
