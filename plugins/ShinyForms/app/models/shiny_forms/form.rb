# frozen_string_literal: true

module ShinyForms
  # Model for ShinyCMS forms
  class Form < ApplicationRecord
    include ShinyName
    include ShinySlug

    # Specify policy class for Pundit
    def policy_class
      ::Admin::FormPolicy
    end

    def self.policy_class
      ::Admin::FormPolicy
    end
  end
end
