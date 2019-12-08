# Pundit policy for elements in shared content admin area
class Admin::SharedContentElementPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def create?
    user.can? 'add_shared_content'
  end

  def delete?
    user.can? 'delete_shared_content'
  end
end
