# Pundit policy for news post admin
# Translates from :news_post' model to :news capability, for better UX (I hope)
class Admin::NewsPostPolicy < Admin::DefaultPolicy
  def index?
    unless @record.class.method_defined?( :first ) && @record.first.present?
      can_list_nil?
    end

    @this_user.can? :list, :news
  end

  def create?
    @this_user.can? :add, :news
  end

  def new?
    create?
  end

  def update?
    @this_user.can? :edit, :news
  end

  def edit?
    update?
  end

  def destroy?
    @this_user.can? :destroy, :news
  end
end
