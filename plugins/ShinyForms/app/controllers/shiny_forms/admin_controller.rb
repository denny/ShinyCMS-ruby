# frozen_string_literal: true

module ShinyForms
  # Base controller for ShinyCMS forms plugin admin features
  # Inherits from ShinyCMS AdminController
  class AdminController < ::AdminController
    helper Rails.application.routes.url_helpers
  end
end
