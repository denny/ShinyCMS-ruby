# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Generate a teaser (short preview) from the text in .body (defaults to three paragraphs)
module ShinyTeaser
  extend ActiveSupport::Concern

  included do
    validates :body, presence: true

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
