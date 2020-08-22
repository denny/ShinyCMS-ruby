# frozen_string_literal: true

module ShinyPages
  # Inherits from ShinyCMS MainController
  class MainController < ::MainController
    helper Rails.application.routes.url_helpers
  end
end
