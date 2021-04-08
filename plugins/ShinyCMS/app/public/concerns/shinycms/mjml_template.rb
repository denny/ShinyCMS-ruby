# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ERB MJML content templates - e.g. ShinyNewsletters::Template
  module MJMLTemplate
    extend ActiveSupport::Concern

    include ShinyCMS::Template

    included do
      # Validations

      validates :filename, mjml_syntax: true, if: -> { filename_changed? }

      # Instance methods

      # Create template elements, based on the content of the template file
      def add_elements
        # I am so, so sorry.
        file_content.scan(
          %r{<%=\s+(sanitize|simple_format|url_for)?\(?\s*@elements\[\s*:(\w+)\]\s*\)?\s+%>}
        ).uniq.each do |result|
          added = add_element result[0], result[1]
          raise ActiveRecord::Rollback unless added
        end
      end

      def file_content_with_erb_removed
        file_content.gsub! %r{<%=? [^%]+ %>}, ''
      end
    end

    class_methods do
      # Get a list of available template files from the disk
      def available_templates
        return [] unless template_dir

        filenames = Dir.glob "*#{file_extension}", base: template_dir
        filenames.collect { |filename| filename.remove( file_extension ) }
      end

      def file_extension
        '.html.mjml'
      end
    end
  end
end
