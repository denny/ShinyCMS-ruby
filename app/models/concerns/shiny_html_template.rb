# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviour for ERB HTML content templates - e.g. ShinyPages::Template
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

      # Never parse HTML with a regex.
      erb.scan(
        %r{<%=\s+(sanitize|simple_format|image_tag\(?\s*url_for)?\(?\s*(\w+)\s*\)?(,\s+.*?)?\s*\)?\s+%>}
      ).uniq.each do |result|
        added = add_element result[0], result[1]
        raise ActiveRecord::Rollback unless added
      end
    end

    # Class methods

    # Get a list of available template files from the disk
    def self.available_templates
      return [] unless template_dir

      filenames = Dir.glob '*.html.erb', base: template_dir
      filenames.collect { |filename| filename.remove( '.html.erb' ) }
    end
  end
end
