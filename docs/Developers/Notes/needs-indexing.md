# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Ruby console snippet to find database tables that need indexes...

c = ActiveRecord::Base.connection

c.tables.collect do |t|
  columns = c.columns(t).collect(&:name).select {|x| x.ends_with?("_id" || x.ends_with("_type"))}
  indexed_columns = c.indexes(t).collect(&:columns).flatten.uniq
  unindexed = columns - indexed_columns
  unless unindexed.empty?
    puts "#{t}: #{unindexed.join(", ")}"
  end
end
