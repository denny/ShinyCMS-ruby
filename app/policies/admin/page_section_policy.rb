# Pundit policy for page section admin
class Admin::PageSectionPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can? 'list_page_sections'
  end

  def create?
    user.can? 'add_page_sections'
  end

  def new?
    create?
  end

  def update?
    user.can? 'edit_page_sections'
  end

  def edit?
    update?
  end

  def delete?
    user.can? 'delete_page_sections'
  end
end
