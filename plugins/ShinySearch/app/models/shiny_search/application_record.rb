# frozen_string_literal: true

module ShinySearch
  # Base model class for <%= camelized_modules =>
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
