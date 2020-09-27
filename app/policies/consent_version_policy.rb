# frozen_string_literal: true

# Pundit policy for users
class ConsentVersionPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :list, :consent_versions
  end

  def show?
    edit?
  end

  def new?
    @this_user.can? :add, :consent_versions
  end

  def create?
    new?
  end

  def edit?
    @this_user.can? :edit, :consent_versions
  end

  def update?
    edit?
  end

  def destroy?
    @this_user.can? :destroy, :consent_versions
  end
end
