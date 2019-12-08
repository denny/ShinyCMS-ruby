# Pundit policy for admin index controller
class AdminPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    @user.can? I18n.t( 'view_admin_area' )
  end
end
