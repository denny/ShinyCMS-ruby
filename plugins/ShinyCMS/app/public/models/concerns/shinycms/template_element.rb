# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common attributes and behaviours that all template element models share
  module TemplateElement
    extend ActiveSupport::Concern

    include ShinyCMS::Element

    included do
      belongs_to :template, inverse_of: :elements

      acts_as_list scope: :template

      validates :template, presence: true
    end

    class_methods do
      def my_demo_data_position
        2  # Template Elements need to be inserted after Templates
      end
    end
  end
end
