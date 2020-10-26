# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviour for ERB MJML content templates - e.g. ShinyNewsletters::Template
module ShinyMJMLTemplate
  extend ActiveSupport::Concern

  include ShinyTemplate

  included do
    # Validations

    validates :filename, mjml_syntax: true, if: -> { filename_changed? }

    # Instance methods

    # Create template elements, based on the content of the template file
    def add_elements
      raise ActiveRecord::Rollback unless file_exists?

      file = "#{self.class.template_dir}/#{filename}.html.mjml"
      mjml = File.read file

      # I am so, so sorry.
      mjml.scan(
        %r{<%=\s+(sanitize|simple_format|image_tag)?\(?\s*@elements\[\s*:(\w+)\](\s*\)?|\..*service_url.*?)\s+%>}
      ).uniq.each do |result|
        added = add_element result[0], result[1]
        raise ActiveRecord::Rollback unless added
      end
    end

    # Class methods

    # Get a list of available template files from the disk
    def self.available_templates
      return unless template_dir

      template_names = []

      filenames = Dir.glob '*.mjml', base: template_dir
      filenames.each do |filename|
        template_names << filename.remove( '.html.mjml' )
      end

      template_names.sort
    end
  end
end
