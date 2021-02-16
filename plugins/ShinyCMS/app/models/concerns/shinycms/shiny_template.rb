# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for content templates - e.g. ShinyPages::Template, ShinyNewsletters::Template
  module ShinyTemplate
    extend ActiveSupport::Concern

    included do
      # Associations

      has_many :elements, -> { order( :position ) }, inverse_of: :template, dependent: :destroy,
                                                    class_name: 'TemplateElement'

      accepts_nested_attributes_for :elements

      # Validations

      validates :filename, presence: true
      validates :name,     presence: true

      # Before/after actions

      after_create :add_elements

      # Instance methods

      def file_exists?
        self.class.template_file_exists? filename
      end

      # Class methods

      def self.template_file_exists?( filename )
        available_templates.include? filename
      end

      private

      def add_element( formatting, name )
        return add_long_text_element name if formatting == 'simple_format'
        return add_html_element name      if formatting == 'sanitize'
        return add_image_element name     if formatting == 'image_tag' || name.include?( 'image' )

        add_short_text_element name
      end

      def add_short_text_element( name )
        elements.create(
          name:         name,
          element_type: 'short_text'
        )
      end

      def add_long_text_element( name )
        elements.create(
          name:         name,
          element_type: 'long_text'
        )
      end

      def add_html_element( name )
        elements.create(
          name:         name,
          element_type: 'html'
        )
      end

      def add_image_element( name )
        elements.create(
          name:         name,
          element_type: 'image'
        )
      end
    end
  end
end
