# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Generate a teaser (short preview) from the text in .body (defaults to three paragraphs)
  module ShinyTeaser
    extend ActiveSupport::Concern

    included do
      validates :body, presence: true

      def body_longer_than_teaser?( paragraphs: 3 )
        body_paragraphs.size > paragraphs
      end

      def teaser( paragraphs: 3 )
        return body if body_paragraphs.size == 1

        paragraphs = body_paragraphs.size if body_paragraphs.size < paragraphs

        join_paragraphs( body_paragraphs[ 0..( paragraphs - 1 ) ] )
      end

      def body_paragraphs
        return split_by_p_tags(  body ) if contains_p_tags(  body )
        return split_by_br_tags( body ) if contains_br_tags( body )

        [ body ]
      end

      def join_paragraphs( paragraphs )
        return join_with_p_tags(  paragraphs ) if contains_p_tags(  body )
        return join_with_br_tags( paragraphs ) if contains_br_tags( body )
      end

      def split_by_p_tags( text )
        text.split %r{</p>[^<]*<p>}i
      end

      def split_by_br_tags( text )
        text.split %r{<br ?/?>\s*<br ?/?>}i
      end

      def join_with_p_tags( paragraphs )
        paragraphs.join( "\n</p>\n<p>" )
      end

      def join_with_br_tags( paragraphs )
        paragraphs.join "\n<br><br>\n"
      end

      def contains_p_tags( text )
        text.match? %r{</p>[^<]*<p>}i
      end

      def contains_br_tags( text )
        text.match? %r{<br ?/?>\s*<br ?/?>}i
      end
    end
  end
end
