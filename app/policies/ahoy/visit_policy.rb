# frozen_string_literal: true

# Pundit policy for web stats (powered by Ahoy)
class Ahoy::VisitPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  def index?
    @this_user.can? :view_web, :stats
  end

  def search?
    index?
  end
end
