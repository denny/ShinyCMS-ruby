# frozen_string_literal: true

# Pundit policy for inserts (prev: 'shared content')
class Admin::InsertSetPolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :list, :inserts
  end

  def update?
    @this_user.can? :edit, :inserts
  end
end
