# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Generate a teaser/short preview of the text passed in (defaults to .body)
  # with the number of paragraphs requested (defaults to three)
  module HasTeaser
    extend ActiveSupport::Concern

    included do
      def teaser( paragraphs: 3, text: nil )
        text ||= body

        teaser_paragraphs = get_paragraphs( text, paragraphs )

        return join_with_p_tags(  teaser_paragraphs ) if contains_p_tags?(  text )
        return join_with_br_tags( teaser_paragraphs ) if contains_br_tags?( text )

        text
      end

      def get_paragraphs( text, paragraphs )
        all_paragraphs = to_paragraphs( text )

        paragraph_count = [ paragraphs, all_paragraphs.size ].min - 1

        all_paragraphs[ 0..paragraph_count ]
      end

      def to_paragraphs( text )
        return split_by_p_tags(  text ) if contains_p_tags?(  text )
        return split_by_br_tags( text ) if contains_br_tags?( text )

        [ text ]
      end

      def split_by_p_tags( text )
        text.split %r{</p>[^<]*<p>}i
      end

      def split_by_br_tags( text )
        text.split %r{<br ?/?>\s*<br ?/?>}i
      end

      def join_with_p_tags( paragraphs )
        paragraphs.join "\n</p>\n<p>"
      end

      def join_with_br_tags( paragraphs )
        paragraphs.join "\n<br><br>\n"
      end

      def contains_p_tags?( text )
        text.match? %r{</p>[^<]*<p>}i
      end

      def contains_br_tags?( text )
        text.match? %r{<br ?/?>\s*<br ?/?>}i
      end
    end
  end
end
