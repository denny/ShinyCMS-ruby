# Pundit policy for administration of discussions
class Admin::DiscussionsPolicy < Admin::DefaultPolicy
  def hide?
    @this_user.can? :hide, :discussions
  end

  def unhide?
    @this_user.can? :unhide, :discussions
  end

  def lock?
    @this_user.can? :lock, :discussions
  end

  def unlock?
    @this_user.can? :unlock, :discussions
  end
end
