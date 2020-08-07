# frozen_string_literal: true

module ShinyNews
  # Base controller for ShinyCMS news plugin admin features
  # Inherits from ShinyCMS AdminController
  class AdminController < ::AdminController
    helper Rails.application.routes.url_helpers
  end
end
