# frozen_string_literal: true

module ShinyForms
  # ShinyForms base model
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
