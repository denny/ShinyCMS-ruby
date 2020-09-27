# frozen_string_literal: true

# Pundit policy for users
class UserPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :list, :users
  end

  def new?
    @this_user.can? :add, :users
  end

  def create?
    new?
  end

  def edit?
    return @this_user.can? :edit, :admin_users if @record.admin?

    @this_user.can? :edit, :users
  end

  def update?
    edit?
  end

  def destroy?
    return @this_user.can? :destroy, :admin_users if @record.admin?

    @this_user.can? :destroy, :users
  end
end
