# frozen_string_literal: true

# Pundit policy for settings admin area
class SettingPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :list, :settings
  end

  def update?
    @this_user.can? :edit, :settings
  end
end
