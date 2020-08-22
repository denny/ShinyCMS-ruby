# frozen_string_literal: true

module ShinyPages
  # Base model class for ShinyPages
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyPages::Engine.routes.url_helpers
    end

    def self.capability_category_name
      'pages'
    end
  end
end
