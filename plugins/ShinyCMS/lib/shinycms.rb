# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'shinycms/engine'

# Namespace wrapper
module ShinyCMS
  # Build the full plugin collection and stash it in the top-level module for re-use
  def self.plugins
    @plugins ||= ShinyCMS::Plugins.all
  end
end
