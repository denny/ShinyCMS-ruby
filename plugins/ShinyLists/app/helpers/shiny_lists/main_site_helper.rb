# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Helper method for finding mailing lists - part of ShinyLists plugin for ShinyCMS
  module MainSiteHelper
    def find_list_by_slug( slug )
      ShinyLists::List.find_by( slug: slug )
    end
  end
end
