# frozen_string_literal: true

module ShinyProfiles
  # Inherits from ShinyCMS ApplicationController
  class ApplicationController < ::ApplicationController
    helper Rails.application.routes.url_helpers
  end
end
