# frozen_string_literal: true

module ShinyForms
  # Base model for ShinyCMS form handlers plugin
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
  end
end
