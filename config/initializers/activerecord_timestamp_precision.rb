# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    # Override default Rails 6 behavior, so we get timestamps without milliseconds
    class PostgreSQLAdapter
      def supports_datetime_with_precision?
        # :nocov:
        false
        # :nocov:
      end
    end
  end
end
