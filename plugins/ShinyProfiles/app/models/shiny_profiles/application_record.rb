# frozen_string_literal: true

module ShinyProfiles
  # Base model class for ShinyProfiles
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
