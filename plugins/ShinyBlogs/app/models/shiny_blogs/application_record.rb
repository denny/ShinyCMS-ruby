# frozen_string_literal: true

module ShinyBlogs
  # Base model class for ShinyBlogs
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyBlogs::Engine.routes.url_helpers
    end
  end
end
