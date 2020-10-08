# frozen_string_literal: true

# Pundit policy for feature flag administration
class FeatureFlagPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :list, :feature_flags
  end

  def update?
    @this_user.can? :edit, :feature_flags
  end
end
