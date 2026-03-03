# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for use in the host app Gemfile
  class GemfileHelper
    def plugin_names
      requested = ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )
      available = Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ) } - [ 'ShinyCMS' ]

      return requested & available if requested

      available
    end

    def underscore( camel_cased_word )
      word = camel_cased_word.to_s
      word = word.gsub( /([A-Z\d]+)([A-Z][a-z])/, '\1_\2' )
      word = word.gsub( /([a-z\d])([A-Z])/, '\1_\2' )
      word = word.tr( '-', '_' )
      word.downcase
    end
  end
end
