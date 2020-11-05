# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

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
