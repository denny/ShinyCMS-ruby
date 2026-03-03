# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Service object for building an Atom feed out of a ShinyCMS::Post collection
  class AtomFeedBuilder
    def self.call( name, posts )
      new.call( name, posts )
    end

    def call( name, posts )
      feed = ShinyCMS::AtomFeed.new( name )

      feed.build( posts )

      feed.write_file
    end
  end
end
