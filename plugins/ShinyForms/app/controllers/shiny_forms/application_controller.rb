# frozen_string_literal: true

module ShinyForms
  # Base controller for ShinyCMS forms plugin
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end
