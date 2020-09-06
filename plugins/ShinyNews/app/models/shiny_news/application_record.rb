# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Base model class for ShinyNews plugin for ShinyCMS
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyNews::Engine.routes.url_helpers
    end
  end
end
