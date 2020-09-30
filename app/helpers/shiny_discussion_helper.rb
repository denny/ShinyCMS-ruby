# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper methods for templates and controllers dealing with discussions and comments
module ShinyDiscussionHelper
  def allow_anonymous_comments
    Setting.get( :allowed_to_comment )&.downcase == 'anonymous'
  end

  def allow_pseudonymous_comments
    Setting.get( :allowed_to_comment )&.downcase == 'pseudonymous' || allow_anonymous_comments
  end

  def allow_authenticated_comments
    Setting.get( :allowed_to_comment )&.downcase == 'authenticated' || allow_pseudonymous_comments
  end

  def recent_comments_by_user( user, count = 10 )
    Comment.readonly.where( user: user ).recent.limit( count )
  end
end
