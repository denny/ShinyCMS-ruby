# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    # Rails 6 defaults to microsecond accuracy in timestamps, which seems a bit
    # over the top for a CMS (and quite noisy when you're looking at the data).
    # The snippet below reduces timestamp accuracy to seconds, which seems adequate.
    class PostgreSQLAdapter
      NATIVE_DATABASE_TYPES[ :datetime ] = { name: 'timestamp', limit: 0 }

      def supports_datetime_with_precision?
        # :nocov:
        false
        # :nocov:
      end
    end
  end
end
