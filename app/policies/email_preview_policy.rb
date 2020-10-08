# frozen_string_literal: true

# Pundit policy for email previews
class EmailPreviewPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :list, :email_previews
  end

  def show?
    @this_user.can? :show, :email_previews
  end
end
