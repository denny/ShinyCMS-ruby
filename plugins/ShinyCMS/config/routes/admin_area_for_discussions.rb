# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Admin area routes for comments and discussions

get 'comments(/page/:page)', to: 'comments#index',  as: :comments
put 'comments',              to: 'comments#update'
get 'comments/search',       to: 'comments#search', as: :search_comments

scope path: 'comment' do
  put    ':id/show',    to: 'comments#show',          as: :show_comment
  put    ':id/hide',    to: 'comments#hide',          as: :hide_comment
  put    ':id/lock',    to: 'comments#lock',          as: :lock_comment
  put    ':id/unlock',  to: 'comments#unlock',        as: :unlock_comment
  put    ':id/is-spam', to: 'comments#mark_as_spam',  as: :spam_comment
  delete ':id/delete',  to: 'comments#destroy',       as: :destroy_comment
end

scope path: 'discussion' do
  put ':id/show',   to: 'discussions#show',   as: :show_discussion
  put ':id/hide',   to: 'discussions#hide',   as: :hide_discussion
  put ':id/lock',   to: 'discussions#lock',   as: :lock_discussion
  put ':id/unlock', to: 'discussions#unlock', as: :unlock_discussion
end
