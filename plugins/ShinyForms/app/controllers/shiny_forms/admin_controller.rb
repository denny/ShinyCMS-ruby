# frozen_string_literal: true

module ShinyForms
  # Base controller for ShinyCMS forms plugin admin features
  class AdminController < ::AdminController
    helper Rails.application.routes.url_helpers
  end
end
