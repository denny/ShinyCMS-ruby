# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ERB HTML content templates - e.g. ShinyPages::Template
  module HTMLTemplate
    extend ActiveSupport::Concern

    include ShinyCMS::Template

    class_methods do
      def parser_regex
        # Never parse HTML with a regex.
        %r{<%=\s+(sanitize|simple_format|image_tag\(?\s*url_for)?\(?\s*(\w+)\s*\)?(,\s+.*?)?\s*\)?\s+%>}
      end

      def file_extension
        '.html.erb'
      end
    end
  end
end
