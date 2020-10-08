# frozen_string_literal: true

# Pundit policy for administration of discussions
class DiscussionPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def show?
    hide?
  end

  def hide?
    @this_user.can? :hide, :discussions
  end

  def lock?
    @this_user.can? :lock, :discussions
  end

  def unlock?
    lock?
  end
end
