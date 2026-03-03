# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for content templates - e.g. ShinyPages::Template, ShinyNewsletters::Template
  module Template
    extend ActiveSupport::Concern

    included do
      has_many :elements, -> { order( :position ).includes( [ :image_attachment ] ) },
               inverse_of: :template, dependent: :destroy, class_name: 'TemplateElement'

      accepts_nested_attributes_for :elements, allow_destroy: true

      validates :filename, presence: true
      validates :name,     presence: true

      after_create :add_elements

      scope :with_elements, -> { includes( [ :elements ] ) }

      # Create template elements, based on the content of the template file
      def add_elements
        file_content.scan( self.class.parser_regex ).uniq.each do |result|
          added = add_element result.first, result.second
          raise ActiveRecord::Rollback unless added
        end
      end

      def file_content
        raise ActiveRecord::Rollback unless file_exists?

        File.read file_path
      end

      def file_exists?
        self.class.template_file_exists? filename
      end

      def file_path
        klass = self.class
        "#{klass.template_dir}/#{filename}#{klass.file_extension}"
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

    class_methods do
      def template_file_exists?( filename )
        available_templates.include? filename
      end

      def available_templates
        return [] unless template_dir

        filenames = Dir.glob "*#{file_extension}", base: template_dir
        filenames.collect { |filename| filename.remove( file_extension ) }
      end
    end
  end
end
