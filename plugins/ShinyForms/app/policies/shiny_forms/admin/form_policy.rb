# frozen_string_literal: true

module ShinyForms
  # Pundit policy for forms admin area
  # Currently, just inherits from main app default admin policy class
  class Admin::FormPolicy < ::Admin::DefaultPolicy
  end
end
