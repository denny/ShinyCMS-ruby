# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Useful methods for dealing with sortable widgets
module ShinySortable
  def parse_sortable_param( query_string, param_name )
    CGI.parse( query_string )["#{param_name}[]"]
  end

  def apply_sort_order( collection, sort_order )
    sort_order.each_with_index do |id, index|
      collection.find( id ).update!( position: index + 1 )
    end
  end
end
