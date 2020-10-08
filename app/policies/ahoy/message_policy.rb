# frozen_string_literal: true

# Pundit policy for email stats (powered by Ahoy::Email)
class Ahoy::MessagePolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :view_email, :stats
  end

  def search?
    index?
  end
end
