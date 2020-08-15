# frozen_string_literal: true

module ShinyBlogs
  # Inherits from ShinyCMS ApplicationController
  class ApplicationController < ::ApplicationController
    helper Rails.application.routes.url_helpers
  end
end
