# frozen_string_literal: true

# Generate a 'teaser' (short preview) from a 'body' field
module Teaser
  extend ActiveSupport::Concern

  included do
    def teaser( paragraphs: 3 )
      return split_by_p_tags(  paragraphs ) if contains_p_tags
      return split_by_br_tags( paragraphs ) if contains_br_tags

      body
    end

    def split_by_p_tags( paragraphs )
      split_text = body.split %r{</p>[^<]*<p>}i
      split_text[ 0..( paragraphs - 1 ) ].join( "\n</p>\n<p>" )
    end

    def split_by_br_tags( paragraphs )
      split_text = body.split %r{<br ?/?>\s*<br ?/?>}i
      split_text[ 0..( paragraphs - 1 ) ].join "\n<br><br>\n"
    end

    def contains_p_tags
      body.match? %r{</p>[^<]*<p>}i
    end

    def contains_br_tags
      body.match? %r{<br ?/?>\s*<br ?/?>}i
    end
  end
end
