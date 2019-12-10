# Pundit policy for page template admin
class Admin::PageTemplatePolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can? 'list_page_templates'
  end

  def create?
    user.can? 'add_page_templates'
  end

  def new?
    create?
  end

  def update?
    user.can? 'edit_page_templates'
  end

  def edit?
    update?
  end

  def delete?
    user.can? 'delete_page_templates'
  end
end
