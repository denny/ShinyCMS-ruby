# Pundit policy for administration of comments
class Admin::CommentPolicy < Admin::DefaultPolicy
  def hide_comment?
    @this_user.can? :hide, :comments
  end

  def unhide_comment?
    @this_user.can? :hide, :comments
  end

  def lock_comment?
    @this_user.can? :lock, :comments
  end

  def unlock_comment?
    @this_user.can? :lock, :comments
  end

  def delete_comment?
    @this_user.can? :delete, :comments
  end
end
