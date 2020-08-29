# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviour for ERB content templates - e.g. ShinyPages::Template
module ShinyHTMLTemplate
  extend ActiveSupport::Concern

  include ShinyTemplate

  included do
    # Instance methods

    # Create template elements, based on the content of the template file
    def add_elements
      raise ActiveRecord::Rollback unless file_exists?

      file = "#{self.class.template_dir}/#{filename}.html.erb"
      erb = File.read file
      erb.scan(
        %r{<%=\s+(sanitize|simple_format)?\(?\s*(\w+)\s*\)?\s+%>}
      ).uniq.each do |result|
        added = add_element result[0], result[1]
        raise ActiveRecord::Rollback unless added
      end
    end

    # Class methods

    # Get a list of available template files from the disk
    def self.available_templates
      return unless template_dir

      filenames = Dir.glob '*.html.erb', base: template_dir
      template_names = []
      filenames.each do |filename|
        template_names << filename.remove( '.html.erb' )
      end
      template_names.sort
    end

    private

    def add_element( formatting, name )
      return add_image_element name   if formatting.nil? && name.include?( 'image' )
      return add_default_element name if formatting.nil?
      return add_html_element name    if formatting == 'sanitize'

      add_long_text_element name      if formatting == 'simple_format'
    end
  end
end
