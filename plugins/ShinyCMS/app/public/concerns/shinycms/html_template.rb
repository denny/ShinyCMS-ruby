# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ERB HTML content templates - e.g. ShinyPages::Template
  module HTMLTemplate
    extend ActiveSupport::Concern

    include ShinyCMS::Template

    included do
      # Create template elements, based on the content of the template file
      def add_elements
        # Never parse HTML with a regex.
        file_content.scan(
          %r{<%=\s+(sanitize|simple_format|image_tag\(?\s*url_for)?\(?\s*(\w+)\s*\)?(,\s+.*?)?\s*\)?\s+%>}
        ).uniq.each do |result|
          added = add_element result[0], result[1]
          raise ActiveRecord::Rollback unless added
        end
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
        '.html.erb'
      end
    end
  end
end
