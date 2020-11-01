# frozen_string_literal: true

# Pundit policy for mailer previews
class MailerPreviewPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :list, :mailer_previews
  end

  def show?
    @this_user.can? :show, :mailer_previews
  end
end
