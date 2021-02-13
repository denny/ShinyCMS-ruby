# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Supporting methods for loading ShinyCMS plugin gems

def available_plugins
  Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ) }
end

def plugin_names
  requested = ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )

  return requested.uniq.select { |name| available_plugins.include?( name ) } if requested

  available_plugins
end

def underscore( camel_cased_word )
  word = camel_cased_word.to_s
  word = word.gsub( /([A-Z\d]+)([A-Z][a-z])/, '\1_\2' )
  word = word.gsub( /([a-z\d])([A-Z])/, '\1_\2' )
  word = word.tr( '-', '_' )
  word = word.downcase
  word = 'shinycms' if word == 'shiny_cms'
  word
end

def env_var_true?( env_var_name )
  [ 'TRUE', 'YES', 'ON', '1', 1 ].include?( ENV[ env_var_name.to_s.upcase ] )
end
