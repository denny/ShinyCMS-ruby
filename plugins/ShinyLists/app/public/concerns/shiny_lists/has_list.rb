# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# rubocop:disable Style/StaticClass
module ShinyLists
  # Make List.has_many available to other plugins
  class HasList
    # Used in ShinyNewsletters::Send
    def self.list_has_many( things, **args )
      List.has_many( things, **args )
    end
  end
end
# rubocop:enable Style/StaticClass
