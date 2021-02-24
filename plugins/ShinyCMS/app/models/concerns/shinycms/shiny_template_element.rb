# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common attributes and behaviours that all template element models share
  module ShinyTemplateElement
    extend ActiveSupport::Concern

    include ShinyElement

    included do
      # Associations

      belongs_to :template, inverse_of: :elements

      # Plugin features

      acts_as_list scope: :template

      # Validations

      validates :template, presence: true
    end

    class_methods do
      # Template Elements need to be inserted after Templates
      def demo_data_position
        2
      end
    end
  end
end
