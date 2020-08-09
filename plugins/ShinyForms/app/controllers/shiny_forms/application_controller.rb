# frozen_string_literal: true

module ShinyForms
  # Base controller for ShinyCMS forms plugin
  # Inherits from ShinyCMS ApplicationController
  class ApplicationController < ::ApplicationController
    helper Rails.application.routes.url_helpers
  end
end
