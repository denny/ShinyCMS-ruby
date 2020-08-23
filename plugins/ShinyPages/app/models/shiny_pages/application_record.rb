# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Base model class for ShinyPages
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # def url_helpers
    #  ShinyPages::Engine.routes.url_helpers
    # end

    def self.capability_category_name
      'pages'
    end
  end
end
