# frozen_string_literal: true

# Policy to help with more graceful handling of bad requests
class Admin::NilClassPolicy < Admin::DefaultPolicy
  # Catch and warn about attempts to scope auth on a nil
  class Scope < Scope
    def resolve
      raise Pundit::NotDefinedError, 'Cannot scope NilClass'
    end
  end
end
