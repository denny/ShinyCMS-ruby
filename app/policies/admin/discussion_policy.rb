# frozen_string_literal: true

# Pundit policy for administration of discussions
class Admin::DiscussionPolicy < Admin::DefaultPolicy
  def show?
    @this_user.can? :hide, :discussions
  end

  def hide?
    @this_user.can? :hide, :discussions
  end

  def lock?
    @this_user.can? :lock, :discussions
  end

  def unlock?
    @this_user.can? :lock, :discussions
  end
end
