# frozen_string_literal: true

module ShinyInserts
  # Base model class - ShinyInserts plugin for ShinyCMS
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
