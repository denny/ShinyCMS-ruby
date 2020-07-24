# frozen_string_literal: true

# Base model for the dummy test app
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
