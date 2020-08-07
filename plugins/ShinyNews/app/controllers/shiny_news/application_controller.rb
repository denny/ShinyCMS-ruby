# frozen_string_literal: true

module ShinyNews
  # ShinyNews base controller
  class ApplicationController < ::ApplicationController
    helper Rails.application.routes.url_helpers
  end
end
