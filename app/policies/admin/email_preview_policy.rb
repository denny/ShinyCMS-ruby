# Pundit policy for email previews
class Admin::EmailPreviewPolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :list, :email_previews
  end

  def show?
    @this_user.can? :show, :email_previews
  end
end
