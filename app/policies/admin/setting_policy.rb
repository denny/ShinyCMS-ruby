# Pundit policy for settings admin area
class Admin::SettingPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can? 'list_settings'
  end

  def create?
    user.can? 'add_settings'
  end

  def update?
    user.can? 'edit_settings'
  end

  def delete?
    user.can? 'delete_settings'
  end
end
