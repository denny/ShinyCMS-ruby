# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Base model class for ShinyNewsletters
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      Engine.routes.url_helpers
    end
  end
end
