# frozen_string_literal: true

# Pundit policy for comment moderation and spam comment admin
class CommentPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  # Comment moderation

  def show?
    hide?
  end

  def hide?
    @this_user.can? :hide, :comments
  end

  def lock?
    @this_user.can? :lock, :comments
  end

  def unlock?
    lock?
  end

  def destroy?
    @this_user.can? :destroy, :comments
  end

  # Spam comments

  def index?
    @this_user.can? :list, :spam_comments
  end

  def search?
    index?
  end

  def mark_as_spam?
    @this_user.can? :add, :spam_comments
  end

  def update?
    @this_user.can? :destroy, :spam_comments
  end
end
