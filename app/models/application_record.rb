# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.dump_for_demo?
    false
  end
end
