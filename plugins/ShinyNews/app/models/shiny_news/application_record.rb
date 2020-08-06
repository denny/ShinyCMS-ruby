# frozen_string_literal: true

module ShinyNews
  # ShinyNews base model
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
