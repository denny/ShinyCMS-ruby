# Pundit policy for page admin
class Admin::PageSectionPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can? 'list_pages'
  end

  def create?
    user.can? 'add_pages'
  end

  def new?
    create?
  end

  def update?
    user.can? 'edit_pages'
  end

  def edit?
    update?
  end

  def delete?
    user.can? 'delete_pages'
  end
end
