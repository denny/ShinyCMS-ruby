# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def self.dump_for_demo?
    false
  end
end
