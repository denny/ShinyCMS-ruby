# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ERB MJML content templates - e.g. ShinyNewsletters::Template
  module MJMLTemplate
    extend ActiveSupport::Concern

    include ShinyCMS::Template

    included do
      validates :filename, mjml_syntax: true, if: -> { filename_changed? }

      def file_content_with_erb_removed
        file_content.gsub! %r{<%=? [^%]+ %>}, ''
      end
    end

    class_methods do
      def parser_regex
        # Probably never parse MJML with a regex either.
        %r{<%=\s+(sanitize|simple_format|url_for)?\(?\s*@elements\[\s*:(\w+)\]\s*\)?\s+%>}
      end

      def file_extension
        '.html.mjml'
      end
    end
  end
end
