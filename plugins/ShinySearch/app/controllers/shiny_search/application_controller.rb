# frozen_string_literal: true

module ShinySearch
  # Inherits from ShinyCMS ApplicationController
  class ApplicationController < ::MainController
    helper Rails.application.routes.url_helpers
  end
end
