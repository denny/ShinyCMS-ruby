# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'shiny_newsletters/engine'

# Namespace wrapper
module ShinyNewsletters
  mattr_reader :config_list_model

  def self.configure( list_model: nil )
    # rubocop:disable Style/ClassVars
    @@config_list_model = list_model if list_model
    # rubocop:enable Style/ClassVars
  end

  # Default config
  configure( list_model: 'ShinyLists::List' )
end
